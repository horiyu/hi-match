import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/model/himapeople.dart';
import 'package:my_web_app/list.dart'; // Add this line

class UserPage extends StatefulWidget {
  UserPage(this.person);
  // String uid;
  HimaPeople person = HimaPeople(
    id: '',
    mail: '',
    isHima: true,
    name: '',
    deadline: null,
    place: '',
    himaActivitiesIds: [],
  );

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // User? _user;
  bool _isLoading = false;
  // List<HimaPeople> himaPeople = [];

  @override
  void initState() {
    super.initState();
    // get(widget.uid);
    // _getUser();
  }

  // Future get(uid) async {
  //   final snapshot = await FirebaseFirestore.instance.collection('users').get();
  //   final himaPeople = snapshot.docs.firstWhere(
  //     (person) => person.id == uid,
  //     orElse: () => HimaPeople(
  //         id: uid,
  //         mail: '',
  //         isHima: true,
  //         name: "name",
  //         deadline: "12:34",
  //         place: "春日",
  //       ),
  //   setState(() {
  //     this.himaPeople = himaPeople as List<HimaPeople>;
  //   });
  // }
  // Future<void> _getUser() async {
  //   User? user = _auth.currentUser;
  //   setState(() {
  //     _user = user;
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('User Page'),
          ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.person == null
              ? const Center(child: Text('No user signed in'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Container(
                            height: 200,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // ここで背景画像を正しく表示
                                Image.asset(
                                  'images/ひマッチ@4x.png',
                                  fit: BoxFit.cover, // 画像をContainer全体にフィットさせる
                                ),
                                // Positioned(
                                //   bottom: -50,
                                //   left: 16,
                                //   child: Container(
                                //     decoration: BoxDecoration(
                                //       border:
                                //           Border.all(color: Colors.black, width: 4),
                                //       borderRadius: BorderRadius.circular(60),
                                //     ),
                                //     child: CircleAvatar(
                                //       radius: 50,
                                //       foregroundImage:
                                //           AssetImage('images/user-icon.png'),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 150,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 16,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 4),
                                        borderRadius: BorderRadius.circular(60),
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        foregroundImage:
                                            AssetImage('images/user-icon.png'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Background Image
                      SizedBox(height: 60),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.person.name ?? 'Anonymous',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '@${widget.person.id}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(height: 12),

                            // Followers (example - replace with actual follower count)
                            Text(
                              '0 Followers', // Replace with actual follower count
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(height: 16),

                            // Action Button
                            ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const NextPage(),
                                //       settings:
                                //           const RouteSettings(name: '/next_page')),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 38, 173, 252),
                              ),
                              child: Text(widget.person.id ==
                                      FirebaseAuth.instance.currentUser?.uid
                                  ? 'プロフィールを編集する'
                                  : 'フレンド申請する'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
