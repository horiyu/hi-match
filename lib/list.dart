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
        place: "春日",
        // himaActivitiesIds: [],
      );
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
                ListTile(
                  leading: const Icon(Icons.person),
                  title: DataTable(
                    showCheckboxColumn: false,
                    columns: const <DataColumn>[
                      DataColumn(label: Icon(Icons.person)),
                      DataColumn(label: Flexible(child: Text('name'))),
                      DataColumn(
                        label: Flexible(child: Text('deadline')),
                      ),
                      DataColumn(
                        label: Flexible(child: Text('place')),
                      ),
                    ],
                    rows: [
                      if (_isHima)
                        DataRow(
                          onSelectChanged: (value) {
                            //ここでログインユーザーをタップしたときの処理を書く
                          },
                          color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                            return Colors.yellow[100]; // Use the default value.
                          }),
                          cells: [
                            DataCell(Icon(Icons.person)),
                            DataCell(Text(
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
                            )),
                            DataCell(Text(
                              _getCountdownString(himaPeople
                                          .firstWhere(
                                              (person) =>
                                                  person.id ==
                                                  FirebaseAuth.instance
                                                      .currentUser?.uid,
                                              orElse: () => HimaPeople(
                                                    id: '',
                                                    mail: '',
                                                    isHima: false,
                                                    name: 'No Name',
                                                    deadline: null,
                                                    place: '',
                                                  ))
                                          .deadline ??
                                      DateTime.now())
                                  .toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )),
                            DataCell(Text(
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
                            )),
                          ],
                        ),
                      for (var person in himaPeople)
                        if (person.isHima &&
                            person.id != FirebaseAuth.instance.currentUser?.uid)
                          DataRow(
                            onSelectChanged: (value) {
                              //ここで各ひまユーザーをタップしたときの処理を書く
                            },
                            cells: [
                              DataCell(Icon(Icons.person)),
                              DataCell(GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UserPage(person),
                                          settings: const RouteSettings(
                                              name: '/user_page')));
                                },
                                child: Text(
                                  person.name ?? "No Name",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )),
                              DataCell(Text(
                                _getCountdownString(
                                        person.deadline ?? DateTime.now())
                                    .toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                              DataCell(Text(
                                person.place ?? "Nowhere",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                    ],
                  ),
                ),
              ],
            ),
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
                                            _selectTime(context);
                                          },
                                          child: Text(
                                            inputDeadline == DateTime.now()
                                                ? '期限を設定'
                                                : '${inputDeadline.hour}:${inputDeadline.minute}',
                                            style: const TextStyle(
                                                color: Colors.blue),
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
                                                          var himaActivitiesCount =
                                                              himaActivities
                                                                  .docs.length;
                                                          if (himaActivitiesCount <=
                                                              10) {
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
                                                            snackBarInfo =
                                                                'ひまアクティビティを登録しました';
                                                            setState(() {
                                                              _futureHimaActivities =
                                                                  fetchHimaActivities();
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else {
                                                            snackBarInfo =
                                                                'ひまアクティビティは10個まで登録可能です';
                                                          }
                                                          final snackBar =
                                                              SnackBar(
                                                            content: Text(
                                                                snackBarInfo),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  snackBar);
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
                                                return ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      himaActivitiesMap.length >
                                                              10
                                                          ? 10
                                                          : himaActivitiesMap
                                                              .length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    String key =
                                                        himaActivitiesMap.keys
                                                            .elementAt(index);
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
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                        //鍵括弧を適切に閉じる
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
