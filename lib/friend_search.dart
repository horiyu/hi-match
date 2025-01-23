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
        .where('id', isGreaterThanOrEqualTo: query)
        .where('id', isLessThanOrEqualTo: query + '\uf8ff')
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
                              trailing: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  final currentUserData = snapshot.data!;
                                  final sentRequests = List<String>.from(
                                      currentUserData['sentRequests'] ?? []);
                                  final gotRequests = List<String>.from(
                                      currentUserData['gotRequests'] ?? []);
                                  final friends = List<String>.from(
                                      currentUserData['friends'] ?? []);
                                  final isRequestSent =
                                      sentRequests.contains(friend.id);
                                  final isRequestReceived =
                                      gotRequests.contains(friend.id);
                                  final isFriend = friends.contains(friend.id);

                                  return OutlinedButton(
                                    onPressed: () async {
                                      if (isFriend) {
                                        // フレンドを削除する処理
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'friends': FieldValue.arrayRemove(
                                              [friend.id])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(friend.id)
                                            .update({
                                          'friends': FieldValue.arrayRemove([
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ])
                                        });
                                      } else if (isRequestSent) {
                                        // フレンド申請をキャンセルする処理
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'sentRequests':
                                              FieldValue.arrayRemove(
                                                  [friend.id])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(friend.id)
                                            .update({
                                          'gotRequests':
                                              FieldValue.arrayRemove([
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ])
                                        });
                                      } else if (isRequestReceived) {
                                        // フレンド申請を承認する処理
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'gotRequests': FieldValue.arrayRemove(
                                              [friend.id]),
                                          'friends':
                                              FieldValue.arrayUnion([friend.id])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(friend.id)
                                            .update({
                                          'sentRequests':
                                              FieldValue.arrayRemove([
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ]),
                                          'friends': FieldValue.arrayUnion([
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ])
                                        });
                                      } else {
                                        // フレンド申請を送る処理
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          'sentRequests':
                                              FieldValue.arrayUnion([friend.id])
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(friend.id)
                                            .update({
                                          'gotRequests': FieldValue.arrayUnion([
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                          ])
                                        });
                                      }
                                    },
                                    child: Text(isFriend
                                        ? 'フレンド'
                                        : isRequestSent
                                            ? '申請を取り消す'
                                            : isRequestReceived
                                                ? '承認'
                                                : 'フレンド申請'),
                                  );
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPage(friend),
                                    settings:
                                        const RouteSettings(name: '/user_page'),
                                  ),
                                );
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
