import 'package:cloud_firestore/cloud_firestore.dart';

class HimaPeople {
  final String id;
  String? name;
  bool isHima;
  String mail;
  DateTime? deadline;
  String? place;
  List<String>? himaActivitiesIds;
  List<String>? sentRequests;
  List<String>? gotRequests;
  List<String>? friends;

  HimaPeople({
    required this.id,
    required this.name,
    required this.isHima,
    required this.mail,
    required this.deadline,
    required this.place,
    required this.himaActivitiesIds,
    this.sentRequests,
    this.gotRequests,
    this.friends,
  });

  factory HimaPeople.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    var deadline = DateTime.now().subtract(const Duration(minutes: 30));
    if (data['deadline'] != null) {
      deadline = (data['deadline'] as Timestamp).toDate();
    }

    return HimaPeople(
      id: data['id'] ?? "",
      name: data['name'] ?? "",
      isHima: data['isHima'] ?? false,
      mail: data['mail'] ?? "",
      deadline: deadline,
      place: data['place'] ?? "",
      himaActivitiesIds: (data['himaActivitiesIds']
              as List<dynamic>?) // 明示的に List<dynamic>? にキャスト
          ?.map((item) => item as String) // 各要素を String にキャスト
          .toList(), // List<String> に変換
      friends: (data['friends'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "name": name,
      "isHima": isHima,
      "mail": mail,
      "deadline": deadline,
      "place": place,
      "himaActivitiesIds": himaActivitiesIds,
      "friends": friends,
    };
  }

  int isFriend(id) {
    if (friends?.contains(id) ?? false) {
      return 3;
    } else if (sentRequests?.contains(id) ?? false) {
      return 2;
    } else if (gotRequests?.contains(id) ?? false) {
      return 1;
    } else {
      return 0;
    }
  }
}
