import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_web_app/model/himapeople.dart';

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
      return HimaPeople.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
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
                              title: Text(friend.name ?? 'No Name'),
                              subtitle: Text(friend.mail),
                              onTap: () {
                                // フレンド詳細ページに遷移する処理を追加
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
