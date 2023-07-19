// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SocialMediaLinks {
  String? facebook;
  String? twitter;
  String? instagram;
  String? linkedin;
  String? youtube;
  String? tiktok;
  String? snapchat;
  SocialMediaLinks({
    this.facebook,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.youtube,
    this.tiktok,
    this.snapchat,
  }) {
    // if null then set it to null
    (facebook ?? '').isEmpty ? facebook = null : facebook = facebook;
    (twitter ?? '').isEmpty ? twitter = null : twitter = twitter;
    (instagram ?? '').isEmpty ? instagram = null : instagram = instagram;
    (linkedin ?? '').isEmpty ? linkedin = null : linkedin = linkedin;
    (youtube ?? '').isEmpty ? youtube = null : youtube = youtube;
    (tiktok ?? '').isEmpty ? tiktok = null : tiktok = tiktok;
    (snapchat ?? '').isEmpty ? snapchat = null : snapchat = snapchat;
  }

  SocialMediaLinks copyWith({
    String? facebook,
    String? twitter,
    String? instagram,
    String? linkedin,
    String? youtube,
    String? tiktok,
    String? snapchat,
  }) {
    return SocialMediaLinks(
      facebook: facebook ?? this.facebook,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      linkedin: linkedin ?? this.linkedin,
      youtube: youtube ?? this.youtube,
      tiktok: tiktok ?? this.tiktok,
      snapchat: snapchat ?? this.snapchat,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'linkedin': linkedin,
      'youtube': youtube,
      'tiktok': tiktok,
      'snapchat': snapchat,
    };
  }

  factory SocialMediaLinks.fromMap(Map<String, dynamic> map) {
    return SocialMediaLinks(
      facebook: map['facebook'] != null ? map['facebook'] as String : null,
      twitter: map['twitter'] != null ? map['twitter'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      linkedin: map['linkedin'] != null ? map['linkedin'] as String : null,
      youtube: map['youtube'] != null ? map['youtube'] as String : null,
      tiktok: map['tiktok'] != null ? map['tiktok'] as String : null,
      snapchat: map['snapchat'] != null ? map['snapchat'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SocialMediaLinks.fromJson(String source) =>
      SocialMediaLinks.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SocialMediaLinks(facebook: $facebook, twitter: $twitter, instagram: $instagram, linkedin: $linkedin, youtube: $youtube, tiktok: $tiktok, snapchat: $snapchat)';
  }

  @override
  bool operator ==(covariant SocialMediaLinks other) {
    if (identical(this, other)) return true;

    return other.facebook == facebook &&
        other.twitter == twitter &&
        other.instagram == instagram &&
        other.linkedin == linkedin &&
        other.youtube == youtube &&
        other.tiktok == tiktok &&
        other.snapchat == snapchat;
  }

  @override
  int get hashCode {
    return facebook.hashCode ^
        twitter.hashCode ^
        instagram.hashCode ^
        linkedin.hashCode ^
        youtube.hashCode ^
        tiktok.hashCode ^
        snapchat.hashCode;
  }
}
