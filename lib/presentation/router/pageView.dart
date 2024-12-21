import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/state/me/provider.dart';
import '../../domain/types/user.dart';
import '../pages/hima_list.dart';
import '../pages/notice.dart';
import '../pages/plan.dart';
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

    final List<Widget> widgetOptions = <Widget>[
      const HimaListPage(),
      PlanPage(),
      const HimaListPage(),
      NoticePage(),
      meAsyncValue.when(
        data: (me) => ProfilePage(user: me as User),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('エラーが発生しました')),
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
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              activeIcon: Icon(Icons.notifications_rounded),
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
