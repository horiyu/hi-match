import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_web_app/presentation/pages/friend.dart';
import 'package:my_web_app/presentation/pages/plan.dart';

import '../../application/state/me/provider.dart';
import '../pages/hima_list.dart';
import '../pages/profile.dart';
import '../router/page_path.dart';

class ViewPage extends ConsumerStatefulWidget {
  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends ConsumerState<ViewPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final meAsyncValue = ref.watch(meProvider);

    meAsyncValue.when(
      data: (user) {
        print('user: $user');
        if (user == null) {
          // サインインしていない場合はサインインページにリダイレクト
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(PagePath.signIn.path); // サインインページのパスに変更してください
          });
        }
      },
      loading: () => {},
      error: (err, stack) => {},
    );

    final List<Widget> widgetOptions = <Widget>[
      HimaListPage(),
      PlanPage(),
      HimaListPage(),
      FriendPage(),
      meAsyncValue.when(
        data: (user) => ProfilePage(user: user),
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
      ),
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return MaterialApp(
      home: Scaffold(
        body: widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today),
              label: 'Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_rounded),
              activeIcon: Icon(Icons.add_circle_rounded),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Friend',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}
