import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_web_app/domain/types/user.dart';
import 'package:my_web_app/presentation/widgets/pill_elavated_button.dart';

import '../../application/state/me/provider.dart';
import '../../domain/features/hima_checker.dart';
import '../widgets/user_icon.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final bool _isCheckedHima = HimaChecker(
      isHima: user.isHima,
      deadline: user.deadline,
    ).checkHima();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            UserIcon(
              size: 100,
              isDisplayedStatus: true,
              isStatus: _isCheckedHima,
            ),
            const SizedBox(height: 20),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '@${user.handle}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Consumer(
              builder: (context, ref, child) {
                // final meAsyncValue = ref.watch(meProvider);

                // meAsyncValue.when(
                //   data: (me) => ElevatedButton(
                //     onPressed: () {
                //       if (me.uid == user.uid) {
                //         // Navigate to edit profile page
                //       } else {
                //         // Follow user action
                //       }
                //     },
                //     child: const Text('フォロー'),
                //   ),
                //   loading: () => const CircularProgressIndicator(),
                //   error: (err, stack) => const Text('エラーが発生しました'),
                // );

                final meUid = ref.watch(meProvider).maybeWhen(
                      data: (me) => me?.uid,
                      orElse: () => null,
                    );

                if (meUid == user.uid) {
                  return PillElevatedButton(
                    onPressed: () {
                      // Navigate to edit profile page
                    },
                    child: const Text('プロフィールを編集'),
                  );
                } else {
                  return PillElevatedButton(
                    onPressed: () {
                      // Follow user action
                    },
                    child: const Text('フォロー'),
                  );
                }

                // if (me.uid == user.uid) {
                //   return ElevatedButton(
                //     onPressed: () {
                //       // Navigate to edit profile page
                //     },
                //     child: const Text('プロフィールを編集'),
                //   );
                // } else {
                //   return ElevatedButton(
                //     onPressed: () {
                //       // Follow user action
                //     },
                //     child: const Text('フォロー'),
                //   );
                // }
              },
            )
          ],
        ),
      ),
    );
  }
}
