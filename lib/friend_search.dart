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

  Future<String> _getButtonText(HimaPeople friend) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final currentUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.uid)
        .get();

    if (currentUserDoc.exists) {
      final currentUserData = currentUserDoc.data()!;
      final friends = List<String>.from(currentUserData['friends'] ?? []);
      final sentRequests =
          List<String>.from(currentUserData['sentRequests'] ?? []);
      final gotRequests =
          List<String>.from(currentUserData['gotRequests'] ?? []);

      if (friends.contains(friend.id)) {
        return "友達です";
      } else if (sentRequests.contains(friend.id)) {
        return "申請済みです";
      } else if (gotRequests.contains(friend.id)) {
        return "申請を許可しますか？";
      }
    }
    return "フォロー";
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
                            return FutureBuilder<String>(
                              future: _getButtonText(friend),
                              builder: (context, snapshot) {
                                final buttonText = snapshot.data ?? "読み込み中...";

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
                                  trailing: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(buttonText),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserPage(friend),
                                        settings: const RouteSettings(
                                            name: '/user_page'),
                                      ),
                                    );
                                  },
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
