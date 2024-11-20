import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:my_web_app/main.dart';
import 'package:my_web_app/model/himapeople.dart';
import 'package:my_web_app/firebase/firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:my_web_app/user_page.dart';

class NextPage extends StatefulWidget {
  const NextPage({super.key});

  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  List<HimaPeople> himapeopleSnapshot = [];
  List<HimaPeople> himaPeople = [];
  bool isLoading = false;
  late String name;

  Map<String, bool> values = {
    'ご飯食べ行こ': false,
    '昼寝しよう': false,
    '散歩しよう': false,
  };

  bool _isHima = false;
  String myperson = "";

  String _getCountdownString(DateTime deadline) {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return "Time's up!";
    }

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Map<String, Map<String, dynamic>> himaActivitiesMap = {};
  late Future<Map<String, Map<String, dynamic>>> _futureHimaActivities;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
    get();
    _futureHimaActivities = fetchHimaActivities();

    // 1秒ごとに再描画するためのタイマーを設定
    Timer.periodic(const Duration(seconds: 1), (timer) {
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

    bool isHima = snapshot.docs[0].data()['isHima'];

    setState(() {
      _isHima = isHima;
    });
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

  void _toggleHimaStatus(int index) async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final email = user?.email;
    bool isLogin = FirebaseAuth.instance.currentUser != null;
    if (!isLogin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
          settings: const RouteSettings(name: '/my_home_page'),
        ),
      );
    }
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
          place: "春日");
      await addHimaPerson(newPerson);
    } else {
      isHima = snapshot.docs[0].data()['isHima'];
      await FirebaseFirestore.instance
          .collection("users")
          .doc(snapshot.docs[0].id)
          .update({'isHima': !isHima});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('暇な人リスト'),
        leading: Row(
          children: [
            const Icon(Icons.person),
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
            ),
            child: const Text('ログアウト'),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                      settings: const RouteSettings(name: '/my_app'),
                    ));
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
                  const ListTile(
                    leading: Icon(Icons.person),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Name'),
                        Text('Deadline'),
                        Text('Place'),
                      ],
                    ),
                  ),
                  if (_isHima)
                    Container(
                      color: Colors.yellow[100],
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
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
                                              ))
                                      .name ??
                                  "No Name",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Text(
                            //   himaPeople
                            //           .firstWhere(
                            //               (person) =>
                            //                   person.id ==
                            //                   FirebaseAuth
                            //                       .instance.currentUser?.uid,
                            //               orElse: () => HimaPeople(
                            //                     id: '',
                            //                     mail: '',
                            //                     isHima: false,
                            //                     name: 'No Name',
                            //                     deadline: null,
                            //                     place: '',
                            //                   ))
                            //           .deadline ??
                            //       null,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            // ),
                            Text(
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
                                              ))
                                      .place ??
                                  "Nowhere",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  for (var person in himaPeople)
                    if (person.isHima &&
                        person.id != FirebaseAuth.instance.currentUser?.uid)
                      ListTile(
                        leading: IconButton(
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
                        ),
                        title: Row(
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
                        ),
                      ),
                ]),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Center(
          child: ToggleSwitch(
            minWidth: 130.0,
            minHeight: 90.0,
            cornerRadius: 50.0,
            activeFgColor: Colors.white,
            inactiveBgColor: Colors.grey,
            inactiveFgColor: Colors.white,
            activeBgColors: const [
              [Colors.black45, Colors.black26],
              [Color.fromARGB(255, 75, 159, 78), Colors.green]
            ],
            animate:
                true, // with just animate set to true, default curve = Curves.easeIn
            curve: Curves
                .bounceInOut, // animate must be set to true when using custom curve
            initialLabelIndex: _isHima ? 1 : 0,
            totalSwitches: 2,
            labels: const ['忙', '暇'],
            onToggle: (index) async {
              _toggleHimaStatus(index!);
              if (!_isHima) {
                final user = FirebaseAuth.instance.currentUser;
                final uid = user?.uid;
                final snapshot = await FirebaseFirestore.instance
                    .collection("users")
                    .where("id", isEqualTo: uid)
                    .get();
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      // title: const Text('暇ステータスを変更しました'),
                      content: SizedBox(
                        width: 500,
                        child: Navigator(
                          onGenerateRoute: (settings) {
                            return MaterialPageRoute(
                              builder: (context) {
                                return Scaffold(
                                  appBar: AppBar(
                                    title: const Text('暇ステータスを変更しました'),
                                  ),
                                  body: Center(
                                    child: Column(
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            DatePicker.showTimePicker(
                                              context,
                                              showTitleActions: true,
                                              showSecondsColumn: false,
                                              onChanged: (date) {},
                                              onConfirm: (date) {
                                                setState(() {});
                                              },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.jp,
                                            );
                                          },
                                          child: const Text(
                                            '日付を選択',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                String newActivity = '';
                                                return AlertDialog(
                                                  title: const Text('新規入力'),
                                                  content: TextField(
                                                    onChanged: (value) {
                                                      newActivity = value;
                                                    },
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText: "新しいアクティビティを入力",
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        if (newActivity
                                                            .isNotEmpty) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "users")
                                                              .doc(snapshot
                                                                  .docs[0].id)
                                                              .collection(
                                                                  "himaActivities")
                                                              .add({
                                                            'icon': 'person',
                                                            'content':
                                                                newActivity,
                                                          });
                                                          setState(() {
                                                            _futureHimaActivities =
                                                                fetchHimaActivities();
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                      child: const Text('追加'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('キャンセル'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: const Text('新規入力'),
                                        ),
                                        SizedBox(
                                          // height: 500,
                                          child: FutureBuilder<
                                              Map<String,
                                                  Map<String, dynamic>>>(
                                            future: _futureHimaActivities,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<
                                                        Map<
                                                            String,
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (!snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return const Text(
                                                    'No activities found');
                                              } else {
                                                Map<String,
                                                        Map<String, dynamic>>
                                                    himaActivitiesMap =
                                                    snapshot.data!;
                                                return ListView(
                                                  shrinkWrap: true,
                                                  children: himaActivitiesMap
                                                      .keys
                                                      .map((String key) {
                                                    return StatefulBuilder(
                                                      builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setState) {
                                                        return CheckboxListTile(
                                                          title: Text(
                                                              himaActivitiesMap[
                                                                      key]![
                                                                  'content']),
                                                          value:
                                                              himaActivitiesMap[
                                                                      key]![
                                                                  'selected'],
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              himaActivitiesMap[
                                                                          key]![
                                                                      'selected'] =
                                                                  value!;
                                                            });
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }).toList(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
