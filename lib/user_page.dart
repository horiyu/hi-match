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
    // himaActivitiesIds: [],
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
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('images/user-icon.jpg'),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Tooltip(
                                message:
                                    widget.person.isHima ? 'ひま〜' : 'ひまじゃない',
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: widget.person.isHima
                                        ? Colors.green
                                        : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('${widget.person.name ?? 'Anonymous'}',
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(height: 16),
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
                                Colors.black, // Set the button color to black
                          ),
                          child: const Text('フレンド申請する'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
