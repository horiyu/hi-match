import 'package:cloud_firestore/cloud_firestore.dart';

class HimaPeople {
  String id;
  String? name;
  bool isHima;
  String mail;
  DateTime? deadline;
  String? place;
  // List<String>? himaActivitiesIds;

  HimaPeople({
    required this.id,
    required this.name,
    required this.isHima,
    required this.mail,
    required this.deadline,
    required this.place,
    // required this.himaActivitiesIds,
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
      // // himaActivitiesIds: data['himaActivitiesIds'] ?? [],
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
      // // "himaActivitiesIds": himaActivitiesIds,
    };
  }
}
