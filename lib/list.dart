import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:my_web_app/login_page.dart';
import 'package:my_web_app/main.dart';
import 'package:my_web_app/model/himapeople.dart';
import 'package:my_web_app/firebase/firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:my_web_app/user_page.dart';
import 'package:my_web_app/hima_modal.dart';

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

  Future get() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final himaPeople = snapshot.docs
        .map((doc) => HimaPeople.fromFirestore(
            doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    setState(() {
      this.himaPeople = himaPeople;
    });
  }

  Future<void> addHimaPerson(HimaPeople person) async {
    await FirebaseFirestore.instance.collection('users').add({
      'id': person.id,
      'name': person.name,
      'isHima': person.isHima,
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
    final email = user?.email;
    bool isLogin = FirebaseAuth.instance.currentUser != null;
    // if (!isLogin) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const LoginPage(),
    //       settings: const RouteSettings(name: '/login'),
    //     ),
    //   );
    //   return;
    // }
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: uid)
        .get();
    HimaPeople newPerson;
    bool isHima = true;
    if (snapshot.docs.isEmpty) {
      newPerson = HimaPeople(
        id: '$uid',
        mail: '$email',
        isHima: true,
        name: name,
        deadline: null,
        place: "春日",
        himaActivitiesIds: [],
      );
      await addHimaPerson(newPerson);
    } else {
      isHima = snapshot.docs[0].data()['isHima'];
      // await FirebaseFirestore.instance
      //     .collection("users")
      //     .doc(snapshot.docs[0].id)
      //     .update({'isHima': !isHima});
    }
    setState(() {
      _isHima = !isHima;
    });
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.lightBlue,
              minimumSize: Size(20, 40),
            ),
            child: const Text(
                style: TextStyle(
                  fontSize: 10,
                ),
                'ログアウト'),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
              } catch (e) {
                setState(() {});
              }
            },
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
                      subtitle: Text(
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
                                .place ??
                            "Nowhere",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                        ),
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
                        subtitle: Table(
                          children: <TableRow>[
                            TableRow(
                              children: [
                                Text(
                                  person.place ?? "Nowhere",
                                  maxLines: 1, // 表示する最大行数を1行に制限
                                  overflow: TextOverflow
                                      .ellipsis, // テキストが制限を超えた場合に省略記号を表示
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            _getCountdownString(
                              person.deadline ?? DateTime.now(),
                            ),
                          ],
                        ),
                      ),
                // Column(
                //   children: [
                //     _getCountdownString(
                //         person.deadline ?? DateTime.now()),
                //   ],
                // ),
                //         Column(
                //           children: [
                //             Text(
                //               person.place ?? "Nowhere",
                //               maxLines: 1, // 表示する最大行数を1行に制限
                //               overflow: TextOverflow
                //                   .ellipsis, // テキストが制限を超えた場合に省略記号を表示
                //             ),
                //           ],
                //         ),
                //       ],
                //     )
                //   ],
                // )
                /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              person.name ?? "No Name",
                              maxLines: 1, // 表示する最大行数を1行に制限
                              overflow: TextOverflow
                                  .ellipsis, // テキストが制限を超えた場合に省略記号を表示
                            ),
                            Text(
                              _getCountdownString(
                                  person.deadline ?? DateTime.now()),
                              maxLines: 1, // 表示する最大行数を1行に制限
                              overflow: TextOverflow
                                  .ellipsis, // テキストが制限を超えた場合に省略記号を表示
                            ),
                            Text(
                              person.place ?? "Nowhere",
                              maxLines: 1, // 表示する最大行数を1行に制限
                              overflow: TextOverflow
                                  .ellipsis, // テキストが制限を超えた場合に省略記号を表示
                            ),
                          ],
                        ),*/
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
          backgroundColor: Colors.blue[200],
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
        color: const Color.fromARGB(255, 23, 63, 122),
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
                    Navigator.popUntil(context, (route) => route.isFirst);
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
                    Icons.person_add,
                    color: Colors.white,
                    size: 32.0,
                  ),
                  onPressed: () {},
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
