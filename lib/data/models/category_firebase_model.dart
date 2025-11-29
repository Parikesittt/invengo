import 'dart:convert';

class CategoryFirebaseModel {
  String? uid;
  String? name;

  CategoryFirebaseModel({this.uid, this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'uid': uid, 'name': name};
  }

  factory CategoryFirebaseModel.fromMap(Map<String, dynamic> map) {
    return CategoryFirebaseModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryFirebaseModel.fromJson(String source) =>
      CategoryFirebaseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
