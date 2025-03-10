import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var gotFriendRequests = snapshot.data!.docs
              .map((doc) =>
                  (doc['gotRequests'] as List<dynamic>? ?? [])) // null チェックを追加
              .expand((i) => i)
              .toList();

          if (gotFriendRequests.isEmpty) {
            return const Center(
              child: Text('フレンドリクエストがありません'), // 空の場合のメッセージを表示
            );
          }

          return ListView.builder(
            itemCount: gotFriendRequests.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('id', isEqualTo: gotFriendRequests[index])
                    .get(),
                builder: (context, userSnapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('エラーが発生しました'),
                    );
                  }

                  var user = userSnapshot.data!.docs.first;

                  return ListTile(
                    title: Text(user['name']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        var currentUser = FirebaseAuth.instance.currentUser;

                        var currentUserSnapshot = FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: currentUser!.uid)
                            .get()
                            .then((currentUserSnapshot) {
                          currentUserSnapshot.docs.first.reference.update({
                            'gotRequests': FieldValue.arrayRemove(
                                [gotFriendRequests[index]]),
                            'friends': FieldValue.arrayUnion(
                                [gotFriendRequests[index]])
                          });
                        });

                        // 相手のデータも更新
                        var friendSnapshot = FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: gotFriendRequests[index])
                            .get()
                            .then((friendSnapshot) {
                          friendSnapshot.docs.first.reference.update({
                            'sentRequests':
                                FieldValue.arrayRemove([currentUser.uid]),
                            'friends': FieldValue.arrayUnion([currentUser.uid])
                          });
                        });
                      },
                      child: Text('承認'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Notification {
  final String title;
  final String body;

  Notification(this.title, this.body);
}

final List<Notification> notifications = [
  Notification('Notification 1', 'This is the body of notification 1'),
  Notification('Notification 2', 'This is the body of notification 2'),
  Notification('Notification 3', 'This is the body of notification 3'),
];

class FriendRequest {
  final String title;
  final String body;

  FriendRequest(this.title, this.body);
}

final List<FriendRequest> friendRequest = [
  FriendRequest('Notification 1', 'This is the body of notification 1'),
  FriendRequest('Notification 2', 'This is the body of notification 2'),
  FriendRequest('Notification 3', 'This is the body of notification 3'),
];
