// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvoiceModule {
  String? uid;
  String? shopUID;
  String? subscriptionDocUID;
  String? subscriptionSettingUID;
  double? amount;
  String? tapTransactionID;
  DateTime? date;
  InvoiceModule({
    this.uid,
    this.shopUID,
    this.subscriptionDocUID,
    this.subscriptionSettingUID,
    this.amount,
    this.tapTransactionID,
    this.date,
  });

  InvoiceModule copyWith({
    String? uid,
    String? shopUID,
    String? subscriptionDocUID,
    String? subscriptionSettingUID,
    double? amount,
    String? tapTransactionID,
    DateTime? date,
  }) {
    return InvoiceModule(
      uid: uid ?? this.uid,
      shopUID: shopUID ?? this.shopUID,
      subscriptionDocUID: subscriptionDocUID ?? this.subscriptionDocUID,
      subscriptionSettingUID:
          subscriptionSettingUID ?? this.subscriptionSettingUID,
      amount: amount ?? this.amount,
      tapTransactionID: tapTransactionID ?? this.tapTransactionID,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'shopUID': shopUID,
      'subscriptionDocUID': subscriptionDocUID,
      'subscriptionSettingUID': subscriptionSettingUID,
      'amount': amount,
      'tapTransactionID': tapTransactionID,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory InvoiceModule.fromMap(Map<String, dynamic> map, {String? uid}) {
    return InvoiceModule(
      uid: uid ?? (map['uid'] != null ? map['uid'] as String : null),
      shopUID: map['shopUID'] != null ? map['shopUID'] as String : null,
      subscriptionDocUID: map['subscriptionDocUID'] != null
          ? map['subscriptionDocUID'] as String
          : null,
      subscriptionSettingUID: map['subscriptionSettingUID'] != null
          ? map['subscriptionSettingUID'] as String
          : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
      tapTransactionID: map['tapTransactionID'] != null
          ? map['tapTransactionID'] as String
          : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceModule.fromJson(String source) =>
      InvoiceModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvoiceModule(uid: $uid, shopUID: $shopUID, subscriptionDocUID: $subscriptionDocUID, subscriptionSettingUID: $subscriptionSettingUID, amount: $amount, tapTransactionID: $tapTransactionID, date: $date)';
  }

  @override
  bool operator ==(covariant InvoiceModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.shopUID == shopUID &&
        other.subscriptionDocUID == subscriptionDocUID &&
        other.subscriptionSettingUID == subscriptionSettingUID &&
        other.amount == amount &&
        other.tapTransactionID == tapTransactionID &&
        other.date == date;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        shopUID.hashCode ^
        subscriptionDocUID.hashCode ^
        subscriptionSettingUID.hashCode ^
        amount.hashCode ^
        tapTransactionID.hashCode ^
        date.hashCode;
  }
}
