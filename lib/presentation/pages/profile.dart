import 'package:flutter/material.dart';
import 'package:my_web_app/domain/types/user.dart';

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
            ElevatedButton(
              onPressed: () {
                // Add your logout logic here
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
