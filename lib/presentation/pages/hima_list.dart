import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/state/hima_list/provider.dart';
import '../../domain/features/hima_checker.dart';
import '../theme/colors.dart';
import '../widgets/count_down_widget.dart';
import '../widgets/tag_button.dart';
import '../widgets/user_icon.dart';

class HimaListPage extends ConsumerWidget {
  const HimaListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsyncValue = ref.watch(himaListProvider);

    final bool isMeHima = usersAsyncValue.whenData((users) {
          return HimaChecker(
            isHima: users.first.isHima,
            deadline: users.first.deadline,
          ).checkHima();
        }).value ??
        false;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: UserIcon(
            size: 50,
            isDisplayedStatus: true,
            isStatus: isMeHima,
          ),
        ),
      ),
      body: usersAsyncValue.when(
        data: (users) => ListView.builder(
          itemExtent: 70,
          itemCount: users.length,
          itemBuilder: (context, index) {
            users.sort((a, b) {
              if (HimaChecker(isHima: a.isHima, deadline: a.deadline)
                      .checkHima() &&
                  !HimaChecker(isHima: b.isHima, deadline: b.deadline)
                      .checkHima()) {
                return -1;
              }
              if (!HimaChecker(isHima: a.isHima, deadline: a.deadline)
                      .checkHima() &&
                  HimaChecker(isHima: b.isHima, deadline: b.deadline)
                      .checkHima()) {
                return 1;
              }
              if (a.uid == 'S5EcL2tMsWcMWK6cNV0ugFYaqpB2') return -1;
              if (b.uid == 'S5EcL2tMsWcMWK6cNV0ugFYaqpB2') return 1;
              return b.deadline.compareTo(a.deadline);
            });

            final user = users[index];
            bool isMe = user.uid == 'S5EcL2tMsWcMWK6cNV0ugFYaqpB2';
            bool isCheckedHima = HimaChecker(
              isHima: user.isHima,
              deadline: user.deadline,
            ).checkHima();

            return ListTile(
              leading: Opacity(
                opacity: isCheckedHima ? 1 : 0.3,
                child: UserIcon(
                  size: 50,
                  isDisplayedStatus: isCheckedHima,
                  isStatus: isCheckedHima,
                  isOnTap: true,
                  user: user,
                ),
              ),
              title: Text(
                user.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isCheckedHima
                      ? BrandColors.black
                      : BrandColors.black.withOpacity(0.3),
                ),
              ),
              subtitle: isCheckedHima
                  ? Row(
                      children: [
                        TagButton(
                          text: user.name,
                          height: 25,
                          onTap: () {},
                        ),
                      ],
                    )
                  : null,
              trailing: isCheckedHima
                  ? CountdownWidget(deadline: user.deadline)
                  : null,
              onTap: () {},
              tileColor: isMe
                  ? BrandColors.primary.withOpacity(0.2)
                  : BrandColors.white,
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      // bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
