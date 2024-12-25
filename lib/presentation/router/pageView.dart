import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_web_app/presentation/theme/colors.dart';

import '../../application/state/me/provider.dart';
import '../../domain/types/user.dart';
import '../pages/hima_list.dart';
import '../pages/hima_modal.dart';
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
      meAsyncValue.when(
        data: (me) => HimaModal(me!.uid),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('エラーが発生しました')),
      ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const SizedBox(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            backgroundColor: BrandColors.primary,
            shape: CircleBorder(),
            onPressed: null,
            // onPressed: () {
            //   _toggleHimaStatus();
            //   if (!_isHima) {
            //     final user = FirebaseAuth.instance.currentUser;
            //     final uid = user?.uid;
            //     FirebaseFirestore.instance
            //         .collection("users")
            //         .where("id", isEqualTo: uid)
            //         .get()
            //         .then((snapshot) async {
            //       // var himaActivities = await FirebaseFirestore.instance
            //       //     .collection("users")
            //       //     .doc(snapshot.docs[0].id)
            //       //     .collection("himaActivities")
            //       //     .get();
            //       Map<String, Map<String, dynamic>> himaActivitiesMap = {};
            //       for (var doc in himaActivities.docs) {
            //         himaActivitiesMap[doc.id] = {
            //           'icon': doc.data()['icon'],
            //           'content': doc.data()['content'],
            //           'selected': false,
            //         };
            //       }
            //       showModalBottomSheet(
            //         context: context,
            //         builder: (context) => HimaModal(uid),
            //       ).then((_) {
            //         if (mounted) {
            //           setState(() {
            //             // _isHima = true;
            //           });
            //         }
            //       });
            //     }
            //     );
            //   }
            // },
            child: Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: BrandColors.primary,
          notchMargin: 11.0,
          shape: const AutomaticNotchedShape(
            RoundedRectangleBorder(),
            StadiumBorder(
              side: BorderSide(),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      onPressed: () {
                        onItemTapped(0);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      onPressed: () {
                        onItemTapped(1);
                      },
                    ),
                  ],
                ),
                // IconButton(
                //   icon: const Icon(
                //     Icons.add_circle_rounded,
                //     color: Colors.white,
                //     size: 32.0,
                //   ),
                //   onPressed: () {
                //     onItemTapped(2);
                //   },
                // ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      onPressed: () {
                        onItemTapped(3);
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 32.0,
                      ),
                      onPressed: () {
                        onItemTapped(4);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
