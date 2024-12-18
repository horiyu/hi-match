import 'package:flutter/material.dart';
import 'package:my_web_app/infrastructure/firestore/interface.dart';
import 'package:my_web_app/presentation/theme/colors.dart';
import 'package:my_web_app/presentation/widgets/user_icon.dart';

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
    _isMeHima = me.isHima;
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
            if (a.isHima && !b.isHima) return -1;
            if (!a.isHima && b.isHima) return 1;
            if (a.uid == 'S5EcL2tMsWcMWK6cNV0ugFYaqpB2') return -1;
            if (b.uid == 'S5EcL2tMsWcMWK6cNV0ugFYaqpB2') return 1;
            return b.deadline.compareTo(a.deadline);
          });

          final user = users[index];
          bool isMe = user.uid == 'S5EcL2tMsWcMWK6cNV0ugFYaqpB2';

          return ListTile(
            leading: Opacity(
              opacity: user.isHima ? 1 : 0.5,
              child: UserIcon(
                size: 50,
                // imageUrl: user.avatar,
                isDisplayedStatus: true,
                isStatus: user.isHima,
              ),
            ),
            title: Text(
              user.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: user.isHima
                    ? BrandColors.black
                    : BrandColors.black.withOpacity(0.5),
              ),
            ),
            trailing:
                user.isHima ? CountdownWidget(deadline: user.deadline) : null,
            onTap: () {},
            tileColor:
                isMe ? BrandColors.primary.withOpacity(0.2) : BrandColors.white,
          );
        },
      ),
    );
  }
}
