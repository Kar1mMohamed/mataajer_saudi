// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BannerModule {
  String? uid;
  String? title;
  String? image;
  String? url;
  DateTime? createdAt;
  DateTime? updatedAt;
  BannerModule({
    this.uid,
    this.title,
    this.image,
    this.url,
    this.createdAt,
    this.updatedAt,
  }) {
    createdAt ??= DateTime.now();
    updatedAt ??= DateTime.now();
  }

  BannerModule copyWith({
    String? uid,
    String? title,
    String? image,
    String? url,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BannerModule(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      image: image ?? this.image,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (uid != null) 'uid': uid,
      'title': title,
      'image': image,
      'url': url,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory BannerModule.fromMap(Map<String, dynamic> map) {
    return BannerModule(
      uid: map['uid'] != null ? map['uid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BannerModule.fromJson(String source) =>
      BannerModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BannerModule(uid: $uid, title: $title, image: $image, url: $url, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BannerModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        other.image == image &&
        other.url == url &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        title.hashCode ^
        image.hashCode ^
        url.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
