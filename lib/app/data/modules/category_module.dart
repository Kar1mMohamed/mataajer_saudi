// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryModule {
  String? uid;
  String name;
  CategoryModule({
    this.uid,
    required this.name,
  });

  CategoryModule copyWith({
    String? uid,
    String? name,
  }) {
    return CategoryModule(
      uid: uid ?? this.uid,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'name': name,
    };
  }

  factory CategoryModule.fromMap(Map<String, dynamic> map, String uid) {
    return CategoryModule(
      uid: uid,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModule.fromJson(String source, String uid) =>
      CategoryModule.fromMap(json.decode(source) as Map<String, dynamic>, uid);

  @override
  String toString() => 'CategoryModule(uid: $uid, name: $name)';

  @override
  bool operator ==(covariant CategoryModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.name == name;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode;
}
