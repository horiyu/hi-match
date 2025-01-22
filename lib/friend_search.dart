import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_web_app/model/himapeople.dart';
import 'package:my_web_app/user_page.dart';

class FriendSearch extends StatefulWidget {
  @override
  _FriendSearchState createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearch> {
  final TextEditingController _controller = TextEditingController();
  List<HimaPeople> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchFriend() async {
    setState(() {
      _isLoading = true;
    });

    final query = _controller.text.trim();
    print(query);
    if (query.isEmpty) {
      setState(() {
        _isLoading = false;
        _searchResults = [];
      });
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: query)
        .get();

    final results = snapshot.docs.map((doc) {
      return HimaPeople.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    }).toList();

    setState(() {
      _isLoading = false;
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('フレンド検索'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'フレンドIDで検索',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchFriend,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : _searchResults.isEmpty
                    ? const Text('検索結果がありません')
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final friend = _searchResults[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                              title: Text(
                                friend.name ?? 'No Name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
<<<<<<< HEAD
                              trailing: friend.isFriend(FirebaseAuth
                                          .instance.currentUser?.uid) ==
                                      3
                                  ? OutlinedButton(
                                      onPressed: () {
                                        // Firestoreのデータを更新する処理を追加
                                        var currentUserSnapshot =
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .where('id',
                                                    isEqualTo: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                .get()
                                                .then((currentUserSnapshot) {
                                          currentUserSnapshot
                                              .docs.first.reference
                                              .update({
                                            'friends': FieldValue.arrayRemove(
                                                [friend.id])
                                          });
                                        });

                                        // 相手のデータも更新する処理を追加
                                        var friendSnapshot = FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .where('id', isEqualTo: friend.id)
                                            .get()
                                            .then((friendSnapshot) {
                                          friendSnapshot.docs.first.reference
                                              .update({
                                            'friends': FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance.currentUser?.uid
                                            ])
                                          });
                                        });
                                      },
                                      child: const Text('フレンド'),
                                    )
                                  : friend.isFriend(FirebaseAuth
                                              .instance.currentUser?.uid) ==
                                          2
                                      ? OutlinedButton(
                                          onPressed: () {
                                            // Firestoreのデータを更新する処理を追加
                                            var currentUserSnapshot =
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .where('id',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get()
                                                    .then(
                                                        (currentUserSnapshot) {
                                              currentUserSnapshot
                                                  .docs.first.reference
                                                  .update({
                                                'sentRequests':
                                                    FieldValue.arrayRemove(
                                                        [friend.id])
                                              });
                                            });

                                            // 相手のデータも更新する処理を追加
                                            var friendSnapshot =
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .where('id',
                                                        isEqualTo: friend.id)
                                                    .get()
                                                    .then((friendSnapshot) {
                                              friendSnapshot
                                                  .docs.first.reference
                                                  .update({
                                                'gotRequests':
                                                    FieldValue.arrayRemove([
                                                  FirebaseAuth
                                                      .instance.currentUser?.uid
                                                ])
                                              });
                                            });
                                          },
                                          child: const Text('申請を取り消す'),
                                        )
                                      : ElevatedButton(
                                          onPressed: () async {
                                            if (friend.isFriend(FirebaseAuth
                                                    .instance
                                                    .currentUser
                                                    ?.uid) ==
                                                1) {
                                              var currentUserSnapshot =
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .where('id',
                                                          isEqualTo:
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid)
                                                      .get()
                                                      .then(
                                                          (currentUserSnapshot) {
                                                currentUserSnapshot
                                                    .docs.first.reference
                                                    .update({
                                                  'gotRequests':
                                                      FieldValue.arrayRemove(
                                                          [friend.id]),
                                                  'friends':
                                                      FieldValue.arrayUnion(
                                                          [friend.id])
                                                });
                                              });
                                            } else {
                                              // Firestoreのデータを更新する処理を追加
                                              QuerySnapshot querySnapshot =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .where('id',
                                                          isEqualTo: friend.id)
                                                      .get();

                                              if (querySnapshot
                                                  .docs.isNotEmpty) {
                                                DocumentReference userDoc =
                                                    querySnapshot
                                                        .docs.first.reference;

                                                await userDoc.update({
                                                  'gotRequests':
                                                      FieldValue.arrayUnion([
                                                    FirebaseAuth.instance
                                                        .currentUser?.uid
                                                  ])
                                                });

                                                QuerySnapshot
                                                    currentUserSnapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .where('id',
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser
                                                                    ?.uid)
                                                        .get();

                                                if (currentUserSnapshot
                                                    .docs.isNotEmpty) {
                                                  DocumentReference
                                                      currentUserDoc =
                                                      currentUserSnapshot
                                                          .docs.first.reference;

                                                  await currentUserDoc.update({
                                                    'sentRequests':
                                                        FieldValue.arrayUnion(
                                                            [friend.id])
                                                  });
                                                }
                                              }
                                            }
                                          },
                                          child: friend.isFriend(FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid) ==
                                                  1
                                              ? const Text('承認')
                                              : const Text('フレンド申請'),
                                        ),
                              // ElevatedButton(
                              //   onPressed: () async {
                              //     // Firestoreのデータを更新する処理を追加
                              //     QuerySnapshot querySnapshot =
                              //         await FirebaseFirestore.instance
                              //             .collection('users')
                              //             .where('id', isEqualTo: friend.id)
                              //             .get();

                              //     if (querySnapshot.docs.isNotEmpty) {
                              //       DocumentReference userDoc =
                              //           querySnapshot.docs.first.reference;

                              //       await userDoc.update({
                              //         'gotRequests': FieldValue.arrayUnion([
                              //           FirebaseAuth.instance.currentUser?.uid
                              //         ])
                              //       });

                              //       QuerySnapshot currentUserSnapshot =
                              //           await FirebaseFirestore.instance
                              //               .collection('users')
                              //               .where('id',
                              //                   isEqualTo: FirebaseAuth
                              //                       .instance.currentUser?.uid)
                              //               .get();

                              //       if (currentUserSnapshot.docs.isNotEmpty) {
                              //         DocumentReference currentUserDoc =
                              //             currentUserSnapshot
                              //                 .docs.first.reference;

                              //         await currentUserDoc.update({
                              //           'sentRequests':
                              //               FieldValue.arrayUnion([friend.id])
                              //         });
                              //       }
                              //     }
                              //   },
                              //   child: Text(
                              //     friend.isFriend(FirebaseAuth
                              //                 .instance.currentUser?.uid) ==
                              //             3
                              //         ? 'フレンド済'
                              //         : friend.isFriend(FirebaseAuth
                              //                     .instance.currentUser?.uid) ==
                              //                 2
                              //             ? 'フレンドリクエスト送信済み'
                              //             : friend.isFriend(FirebaseAuth
                              //                         .instance
                              //                         .currentUser
                              //                         ?.uid) ==
                              //                     1
                              //                 ? 'フレンドリクエストを承認'
                              //                 : 'フレンド申請',
                              //   ),
                              // ),
=======
                              trailing: ElevatedButton(
                                onPressed: () {},
                                child: Text("follow"),
                              ),
>>>>>>> origin/develop
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPage(friend),
                                    settings:
                                        const RouteSettings(name: '/user_page'),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
