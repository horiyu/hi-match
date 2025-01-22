import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isMe = false;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isMe = widget.person.id == FirebaseAuth.instance.currentUser?.uid;
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
                            // Text(
                            //   '0 Followers', // Replace with actual follower count
                            //   style: TextStyle(
                            //     color: Colors.grey,
                            //   ),
                            // ),

                            SizedBox(height: 16),

                            // Action Button
                            ElevatedButton(
                              onPressed: isMe
                                  ? () {
                                      setState(() {
                                        isEdit = true;
                                      });
                                    }
                                  : () async {
                                      // Firestoreのデータを更新する処理を追加
                                      QuerySnapshot querySnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .where('id',
                                                  isEqualTo: widget.person.id)
                                              .get();

                                      if (querySnapshot.docs.isNotEmpty) {
                                        DocumentReference userDoc =
                                            querySnapshot.docs.first.reference;

                                        await userDoc.update({
                                          'gotRequests': FieldValue.arrayUnion([
                                            FirebaseAuth
                                                .instance.currentUser?.uid
                                          ])
                                        });

                                        QuerySnapshot currentUserSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .where('id',
                                                    isEqualTo: FirebaseAuth
                                                        .instance
                                                        .currentUser
                                                        ?.uid)
                                                .get();

                                        if (currentUserSnapshot
                                            .docs.isNotEmpty) {
                                          DocumentReference currentUserDoc =
                                              currentUserSnapshot
                                                  .docs.first.reference;

                                          await currentUserDoc.update({
                                            'sentRequests':
                                                FieldValue.arrayUnion(
                                                    [widget.person.id])
                                          });
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 38, 173, 252),
                              ),
                              child: Text(isMe ? 'プロフィールを編集する' : 'フレンド申請する'),
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
