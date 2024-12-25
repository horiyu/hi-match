import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/state/me/provider.dart';
import '../../domain/types/user.dart';
import '../pages/hima_list.dart';
import '../pages/notice.dart';
import '../pages/plan.dart';
import '../pages/profile.dart';
import 'hima_modal.dart';

class ViewPage extends ConsumerStatefulWidget {
  final Widget child;

  const ViewPage({super.key, required this.child});

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
      _buildProfilePage(meAsyncValue),
    ];

    void onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: widget.child,
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
    );
  }

  Widget _buildHimaModal(AsyncValue<User?> meAsyncValue) {
    return meAsyncValue.when(
      data: (me) {
        if (me == null) {
          return const Center(child: Text('ユーザーが見つかりません'));
        }
        return HimaModal(me.uid);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('エラーが発生しました')),
    );
  }

  Widget _buildProfilePage(AsyncValue<User?> meAsyncValue) {
    return meAsyncValue.when(
      data: (me) {
        if (me == null) {
          return const Center(child: Text('ユーザーが見つかりません'));
        }
        return ProfilePage(user: me);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('エラーが発生しました')),
    );
  }
}
