import 'dart:convert';

class TapChargeReq {
  double? amount;
  String? currency = 'SAR';
  bool? threeDSecure = true;
  bool? saveCard = false;
  String? description;
  Reference? reference;
  Receipt? receipt;
  Customer? customer;
  Source? source = Source(id: 'src_all');
  Post? post;
  Post? redirect;
  Metadata? metadata;

  TapChargeReq({
    this.amount,
    this.currency = 'SAR',
    this.threeDSecure = true,
    this.saveCard = false,
    this.description,
    this.reference,
    this.receipt,
    this.customer,
    this.source,
    this.post,
    this.redirect,
    this.metadata,
  });

  TapChargeReq.fromMap(Map<String, dynamic> tapChargeReq) {
    amount = double.parse(tapChargeReq['amount'].toString());
    currency = tapChargeReq['currency'] = 'SAR';
    threeDSecure = tapChargeReq['threeDSecure'] = true;
    saveCard = tapChargeReq['save_card'] = false;
    description = tapChargeReq['description'];
    reference = tapChargeReq['reference'] != null
        ? Reference?.fromJson(tapChargeReq['reference'])
        : null;
    receipt = tapChargeReq['receipt'] != null
        ? Receipt?.fromJson(tapChargeReq['receipt'])
        : null;
    customer = tapChargeReq['customer'] != null
        ? Customer?.fromJson(tapChargeReq['customer'])
        : null;
    source = tapChargeReq['source'] = Source(id: 'src_all');
    post = tapChargeReq['post'] != null
        ? Post?.fromJson(tapChargeReq['post'])
        : null;
    redirect = tapChargeReq['redirect'] != null
        ? Post?.fromJson(tapChargeReq['redirect'])
        : null;
    metadata = tapChargeReq['metadata'] != null
        ? Metadata?.fromJson(tapChargeReq['metadata'])
        : null;
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    data['threeDSecure'] = threeDSecure;
    data['save_card'] = saveCard;
    data['description'] = description;
    if (reference != null) {
      data['reference'] = reference?.toJson();
    }
    if (receipt != null) {
      data['receipt'] = receipt?.toJson();
    }
    if (customer != null) {
      data['customer'] = customer?.toJson();
    }
    if (source != null) {
      data['source'] = source?.toJson();
    }
    if (post != null) {
      data['post'] = post?.toJson();
    }
    if (redirect != null) {
      data['redirect'] = redirect?.toJson();
    }
    if (metadata != null) {
      data['metadata'] = metadata?.toJson();
    }
    return data;
  }

  String toJson() => json.encode(toMap());
}

class Reference {
  String? transaction;
  String? order;

  Reference({this.transaction, this.order});

  Reference.fromJson(Map<String, dynamic> map) {
    transaction = map['transaction'];
    order = map['order'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['transaction'] = transaction;
    data['order'] = order;
    return data;
  }
}

class Receipt {
  bool? email;
  bool? sms;

  Receipt({this.email, this.sms});

  Receipt.fromJson(Map<String, dynamic> map) {
    email = map['email'];
    sms = map['sms'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['email'] = email;
    data['sms'] = sms;
    return data;
  }
}

class Customer {
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  Phone? phone;

  Customer(
      {this.firstName, this.middleName, this.lastName, this.email, this.phone});

  Customer.fromJson(Map<String, dynamic> map) {
    firstName = map['first_name'];
    middleName = map['middle_name'];
    lastName = map['last_name'];
    email = map['email'];
    phone = map['phone'] != null ? Phone?.fromJson(map['phone']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['email'] = email;
    if (phone != null) {
      data['phone'] = phone?.toJson();
    }
    return data;
  }
}

class Phone {
  String? countryCode;
  String? number;

  Phone({this.countryCode, this.number});

  Phone.fromJson(Map<String, dynamic> map) {
    countryCode = map['country_code'];
    number = map['number'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['number'] = number;
    return data;
  }
}

class Source {
  String? id;

  Source({this.id});

  Source.fromJson(Map<String, dynamic> map) {
    id = map['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Post {
  String? url;

  Post({this.url});

  Post.fromJson(Map<String, dynamic> map) {
    url = map['url'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class Metadata {
  String? udf1;

  Metadata({this.udf1});

  Metadata.fromJson(Map<String, dynamic> map) {
    udf1 = map['udf1'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['udf1'] = udf1;
    return data;
  }
}
