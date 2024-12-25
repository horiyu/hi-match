import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_web_app/presentation/theme/colors.dart';

import '../../application/state/me/provider.dart';
import '../../domain/types/user.dart';
import '../pages/hima_list.dart';
import '../pages/hima_modal.dart';
import '../pages/notice.dart';
import '../pages/plan.dart';
import '../pages/profile.dart';

class ViewPage extends ConsumerStatefulWidget {
  const ViewPage({super.key});

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
      _buildHimaModal(meAsyncValue),
      NoticePage(),
      _buildProfilePage(meAsyncValue),
    ];

    return MaterialApp(
      home: Scaffold(
        body: widgetOptions[_selectedIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const FloatingActionButton(
          backgroundColor: BrandColors.primary,
          shape: CircleBorder(),
          onPressed: null,
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: _buildBottomAppBar(),
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

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
      color: BrandColors.primary,
      notchMargin: 11.0,
      shape: const AutomaticNotchedShape(
        RoundedRectangleBorder(),
        StadiumBorder(side: BorderSide()),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavigationIcon(Icons.home_outlined, 0),
            _buildNavigationIcon(Icons.calendar_today, 1),
            _buildNavigationIcon(Icons.notifications_none_rounded, 3),
            _buildNavigationIcon(Icons.person_outline, 4),
          ],
        ),
      ),
    );
  }

  IconButton _buildNavigationIcon(IconData icon, int index) {
    return IconButton(
      icon: Icon(icon, color: Colors.white, size: 30.0),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }
}
