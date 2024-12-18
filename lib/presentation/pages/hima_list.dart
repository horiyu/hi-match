import 'package:flutter/material.dart';
import 'package:my_web_app/infrastructure/firestore/interface.dart';
import 'package:my_web_app/presentation/theme/colors.dart';
import 'package:my_web_app/presentation/widgets/user_icon.dart';

import '../../domain/features/hima_checker.dart';
import '../../domain/types/user.dart';
import '../widgets/count_down_widget.dart';

class HimaListPage extends StatefulWidget {
  final Firestore firestore;

  const HimaListPage({super.key, required this.firestore});

  @override
  State<HimaListPage> createState() => _HimaListPageState();
}

class _HimaListPageState extends State<HimaListPage> {
  bool _isMeHima = false;

  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _getIsMeHima();
    _loadUsers();
  }

  Future<void> _getIsMeHima() async {
    final me =
        await widget.firestore.findUserByUid('S5EcL2tMsWcMWK6cNV0ugFYaqpB2');
    _isMeHima =
        HimaChecker(isHima: me.isHima, deadline: me.deadline).checkHima();
    setState(() {});
  }

  Future<void> _loadUsers() async {
    users = await widget.firestore.getUsers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserIcon(
          size: 50,
          isDisplayedStatus: true,
          isStatus: _isMeHima,
        ),
      )),
      body: ListView.builder(
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
              opacity: isCheckedHima ? 1 : 0.5,
              child: UserIcon(
                size: 50,
                // imageUrl: user.avatar,
                isDisplayedStatus: isCheckedHima,
                isStatus: isCheckedHima,
              ),
            ),
            title: Text(
              user.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCheckedHima
                    ? BrandColors.black
                    : BrandColors.black.withOpacity(0.5),
              ),
            ),
            trailing:
                isCheckedHima ? CountdownWidget(deadline: user.deadline) : null,
            onTap: () {},
            tileColor:
                isMe ? BrandColors.primary.withOpacity(0.2) : BrandColors.white,
          );
        },
      ),
    );
  }
}
