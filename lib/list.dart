import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:my_web_app/friend_search.dart';
import 'package:my_web_app/login_page.dart';
import 'package:my_web_app/main.dart';
import 'package:my_web_app/model/himapeople.dart';
import 'package:my_web_app/firebase/firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:my_web_app/user_page.dart';
import 'package:my_web_app/hima_modal.dart';

import 'notification_page.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  List<HimaPeople> himapeopleSnapshot = [];
  List<HimaPeople> himaPeople = [];
  bool isLoading = false;
  late String name = "";
  List<String> tags = [];

  bool _isHima = false;
  String myperson = "";

  DateTime inputDeadline = DateTime.now();
  bool _switchValue = false; // トグルの状態を保持する変数

  Widget _getCountdownString(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return const Text('期限切れ');
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    if (difference.inHours >= 1) {
      return Text('残り $hours 時間');
    } else if (difference.inMinutes >= 30) {
      return Text('残り ${minutes + 1} 分');
    } else {
      return Text('残り ${minutes + 1} 分',
          style: const TextStyle(color: Colors.red));
    }
  }

  Map<String, Map<String, dynamic>> himaActivitiesMap = {};
  late Future<Map<String, Map<String, dynamic>>> _futureHimaActivities;

  late String snackBarInfo;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
    get();
    _futureHimaActivities = fetchHimaActivities();

    // 1秒ごとに再描画するためのタイマーを設定
    Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _initializeAsync() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .get();

    // bool isHima = snapshot.docs[0].data()['isHima'];

    // setState(() {
    //   _isHima = isHima;
    // });
  }

  Future getHimaPeople() async {
    setState(() => isLoading = true);
    himaPeople = await FirestoreHelper.instance
        .selectAllHimaPeople("Ian4IDN4ryYtbv9h4igNeUdZQkB3");
    setState(() => isLoading = false);
  }

  // Future get() async {
  //   final snapshot = await FirebaseFirestore.instance.collection('users').get();
  //   final himaPeople = snapshot.docs
  //       .map((doc) => HimaPeople.fromFirestore(
  //           doc as DocumentSnapshot<Map<String, dynamic>>))
  //       .toList();
  //   setState(() {
  //     this.himaPeople = himaPeople;
  //   });
  // }
  Future get() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: user.uid)
        .get();

    final friendsUid =
        List<String>.from(snapshot.docs.first.data()['friends'] ?? []);

    final himaPeople = await Future.wait(friendsUid.map((friendUid) async {
      final FriendSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("id", isEqualTo: friendUid)
          .get();

      return HimaPeople.fromFirestore(
          FriendSnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>);
    }));

    // himaPeopleに自分自身追加
    himaPeople.add(HimaPeople.fromFirestore(
        snapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>));

    setState(() {
      this.himaPeople = himaPeople;
    });
  }

  Future<void> _refresh() async {
    await get();
    return Future.delayed(
      const Duration(milliseconds: 500),
    );
  }

  void _toggleHimaStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid == null) {
      // ユーザーがログインしていない場合の処理
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
          settings: const RouteSettings(name: '/login'),
        ),
      );
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .get();

    if (snapshot.docs.isEmpty) {
      // Firestoreにドキュメントが存在しない場合、新しいユーザーを作成
      HimaPeople newPerson = HimaPeople(
        id: uid,
        mail: user?.email ?? "no-email@example.com", // 条件付きアクセスとデフォルト値
        isHima: true,
        name: name,
        deadline: null,
        place: "春日",
        himaActivitiesIds: [],
      );

      await FirebaseFirestore.instance
          .collection("users")
          .add(newPerson.toFirestore());

      setState(() {
        _isHima = true;
      });
    } else {
      // Firestoreから現在の`isHima`を取得して反転させる
      final docRef = snapshot.docs.first.reference;
      bool currentIsHima = snapshot.docs.first.data()['isHima'] ?? false;

      await docRef.update({'isHima': !currentIsHima});

      setState(() {
        _isHima = !currentIsHima; // ローカル状態をFirestoreと同期
      });
    }

    // ユーザーリストを再取得
    get();
  }

  Future<Map<String, Map<String, dynamic>>> fetchHimaActivities() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .get();

    if (snapshot.docs.isEmpty) {
      return {}; // snapshot.docsが空の場合の処理を追加
    }

    var himaActivities = await FirebaseFirestore.instance
        .collection("users")
        .doc(snapshot.docs[0].id)
        .collection("himaActivities")
        .get();

    Map<String, Map<String, dynamic>> himaActivitiesMap = {};
    for (var doc in himaActivities.docs) {
      himaActivitiesMap[doc.id] = {
        'icon': doc.data()['icon'],
        'content': doc.data()['content'],
        'selected': false,
      };
    }
    return himaActivitiesMap;
  }

  Future<void> _selectTime(BuildContext context) async {
    final DateTime? picked = await DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      showSecondsColumn: false,
      currentTime: inputDeadline,
      locale: LocaleType.jp,
      onConfirm: (time) {
        setState(() {
          inputDeadline = time;
        });
      },
    );

    if (picked != null) {
      setState(() {
        inputDeadline = picked;
      });
    }
  }

  Future<List<String>> fetchHimaTags(String userId) async {
    // `users`コレクションで`id`フィールドが`userId`と一致するドキュメントを取得
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where('id', isEqualTo: userId) // `id`フィールドで検索
        .limit(1) // 一致するドキュメントが1つだけと想定
        .get();

    if (querySnapshot.docs.isEmpty) {
      return []; // ドキュメントが見つからない場合は空リストを返す
    }

    // 一致したドキュメントを取得
    final userDoc = querySnapshot.docs.first;

    // `himaActivitiesIds`を取得
    final userHimaIds =
        (userDoc.data()['himaActivitiesIds'] as List<dynamic>? ?? [])
            .map((id) => id as String)
            .toList();

    // `himaActivitiesIds`が空の場合、デフォルトの動作
    if (userHimaIds.isEmpty) {
      return []; // 空のリストを返す
    }

    // `himaActivities`コレクションから`content`を取得
    final activitiesSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userDoc.id) // ドキュメントIDでアクセス
        .collection("himaActivities")
        .get();

    return activitiesSnapshot.docs
        .where((doc) => userHimaIds.contains(doc.id)) // IDでフィルタリング
        .map((doc) => doc['content'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('暇な人リスト'),
        leading: Row(
          children: [
            Expanded(
              child: IconButton(
                iconSize: 32,
                icon: const Icon(Icons.person),
                onPressed: () {
                  var myPerson = himaPeople.firstWhere(
                      (person) =>
                          person.id == FirebaseAuth.instance.currentUser?.uid,
                      orElse: () => HimaPeople(
                            id: '',
                            mail: '',
                            isHima: false,
                            name: 'No Name',
                            deadline: null,
                            place: '',
                            himaActivitiesIds: [],
                          ));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(myPerson),
                        settings: const RouteSettings(name: '/user_page'),
                      ));
                },
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: _isHima ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.grey[300],
          //     foregroundColor: Colors.lightBlue,
          //     minimumSize: Size(20, 40),
          //   ),
          //   child: const Text(
          //       style: TextStyle(
          //         fontSize: 10,
          //       ),
          //       'ログアウト'),
          //   onPressed: () async {
          //     try {
          //       await FirebaseAuth.instance.signOut();
          //       Navigator.popUntil(context, (route) => route.isFirst);
          //     } catch (e) {
          //       setState(() {});
          //     }
          //   },
          // ),

          IconButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                    settings: const RouteSettings(name: '/notifications'),
                  ),
                );
              });
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const BouncingScrollPhysics(),
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.trackpad
            },
          ),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (_isHima)
                  Container(
                    color: Colors.yellow[100],
                    child: ListTile(
                      leading: IconButton(
                          iconSize: 32,
                          icon: const Icon(Icons.person),
                          onPressed: () {
                            var myPerson = himaPeople.firstWhere(
                                (person) =>
                                    person.id ==
                                    FirebaseAuth.instance.currentUser?.uid,
                                orElse: () => HimaPeople(
                                      id: '',
                                      mail: '',
                                      isHima: false,
                                      name: 'No Name',
                                      deadline: null,
                                      place: '',
                                      himaActivitiesIds: [],
                                    ));
                            // ボタンが押された際の動作を記述する
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserPage(myPerson),
                                  settings:
                                      const RouteSettings(name: '/user_page'),
                                ));
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                          )),
                      title: Text(
                        himaPeople
                                .firstWhere(
                                    (person) =>
                                        person.id ==
                                        FirebaseAuth.instance.currentUser?.uid,
                                    orElse: () => HimaPeople(
                                          id: '',
                                          mail: '',
                                          isHima: false,
                                          name: 'No Name',
                                          deadline: null,
                                          place: '',
                                          himaActivitiesIds: [],
                                        ))
                                .name ??
                            "No Name",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: FutureBuilder<List<String>>(
                        future: fetchHimaTags(
                            FirebaseAuth.instance.currentUser?.uid ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return const Text('エラーが発生しました');
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('タグが見つかりません');
                          }

                          final tags = snapshot.data!;
                          return Wrap(
                            spacing: 15.0,
                            children: tags.map((tag) {
                              return Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 7.0),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      trailing: Column(
                        children: [
                          _getCountdownString(
                            himaPeople
                                    .firstWhere(
                                        (person) =>
                                            person.id ==
                                            FirebaseAuth
                                                .instance.currentUser?.uid,
                                        orElse: () => HimaPeople(
                                              id: '',
                                              mail: '',
                                              isHima: false,
                                              name: 'No Name',
                                              deadline: null,
                                              place: '',
                                              himaActivitiesIds: [],
                                            ))
                                    .deadline ??
                                DateTime.now(),
                          ),
                        ],
                      ),
                    ),
                  ),
                for (var person in himaPeople)
                  if (person.isHima &&
                      person.id != FirebaseAuth.instance.currentUser?.uid)
                    if (person.deadline!
                        .isAfter(DateTime.now())) //deadlineが0になった時
                      ListTile(
                        leading: IconButton(
                            iconSize: 32,
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              // ボタンが押された際の動作を記述する
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPage(person),
                                    settings:
                                        const RouteSettings(name: '/user_page'),
                                  ));
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                            )),
                        title: Text(
                          person.name ?? "No Name",
                          maxLines: 1, // 表示する最大行数を1行に制限
                          overflow:
                              TextOverflow.ellipsis, // テキストが制限を超えた場合に省略記号を表示
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: FutureBuilder<List<String>>(
                          future: fetchHimaTags(person.id), // 修正：person.idのみ渡す
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return const Text('エラーが発生しました');
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('タグが見つかりません');
                            }

                            final tags = snapshot.data!;
                            return Wrap(
                              spacing: 15.0,
                              children: tags.map((tag) {
                                return Chip(
                                  label: Text(
                                    tag,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 7.0), // タグの大きさを調整
                                );
                              }).toList(),
                            );
                          },
                        ),
                        trailing: Column(
                          children: [
                            _getCountdownString(
                              person.deadline ?? DateTime.now(),
                            ),
                          ],
                        ),
                      ),
                
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 100,
        height: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          shape: const CircleBorder(),
          onPressed: () {
            _toggleHimaStatus();
            if (!_isHima) {
              final user = FirebaseAuth.instance.currentUser;
              final uid = user?.uid;
              FirebaseFirestore.instance
                  .collection("users")
                  .where("id", isEqualTo: uid)
                  .get()
                  .then((snapshot) async {
                var himaActivities = await FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.docs[0].id)
                    .collection("himaActivities")
                    .get();
                Map<String, Map<String, dynamic>> himaActivitiesMap = {};
                for (var doc in himaActivities.docs) {
                  himaActivitiesMap[doc.id] = {
                    'icon': doc.data()['icon'],
                    'content': doc.data()['content'],
                    'selected': false,
                  };
                }
                showModalBottomSheet(
                  isScrollControlled: true, // これを追加して全画面表示に対応
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.85, // 画面の85%の高さを指定
                  ),
                  context: context,
                  builder: (context) => HimaModal(uid),
                ).then((_) {
                  if (mounted) {
                    setState(() {
                      _isHima = true;
                    });
                  }
                });
              });
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepOrangeAccent,
        notchMargin: 11.0,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 丸い背景
                  // color: Colors.blue[200], // 背景色
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  onPressed: () {
                    
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // 丸い背景
                  // color: Colors.blue[200], // 背景色
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendSearch(),
                        settings: const RouteSettings(name: '/friend_search'),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
