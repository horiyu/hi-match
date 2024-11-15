import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_web_app/main.dart';
import 'package:my_web_app/model/himapeople.dart';
import 'package:my_web_app/firebase/firestore.dart';
import 'package:my_web_app/name_reg.dart';
import 'package:my_web_app/list.dart'; // Add this line
import 'package:toggle_switch/toggle_switch.dart';

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
        title: Text('User Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : widget.person == null
              ? Center(child: Text('No user signed in'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, size: 100),
                      Text('名前: ${widget.person.name ?? 'Anonymous'}'),
                      Text('${widget.person.name} さんは、現在' +
                          (widget.person.isHima ? 'ヒマです' : '忙しい')),
                      SizedBox(height: 8),
                      // Text('Email: ${_user!.email ?? 'No email'}'),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NextPage()),
                          );
                        },
                        child: Text('フォロー'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
