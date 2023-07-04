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

  TapChargeReq(
      {this.amount,
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
      this.metadata});

  TapChargeReq.fromMap(Map<String, dynamic> TapChargeReq) {
    amount = double.parse(TapChargeReq['amount'].toString());
    currency = TapChargeReq['currency'] = 'SAR';
    threeDSecure = TapChargeReq['threeDSecure'] = true;
    saveCard = TapChargeReq['save_card'] = false;
    description = TapChargeReq['description'];
    reference = TapChargeReq['reference'] != null
        ? Reference?.fromJson(TapChargeReq['reference'])
        : null;
    receipt = TapChargeReq['receipt'] != null
        ? Receipt?.fromJson(TapChargeReq['receipt'])
        : null;
    customer = TapChargeReq['customer'] != null
        ? Customer?.fromJson(TapChargeReq['customer'])
        : null;
    source = TapChargeReq['source'] = Source(id: 'src_all');
    post = TapChargeReq['post'] != null
        ? Post?.fromJson(TapChargeReq['post'])
        : null;
    redirect = TapChargeReq['redirect'] != null
        ? Post?.fromJson(TapChargeReq['redirect'])
        : null;
    metadata = TapChargeReq['metadata'] != null
        ? Metadata?.fromJson(TapChargeReq['metadata'])
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

  Reference.fromJson(Map<String, dynamic> TapChargeReq) {
    transaction = TapChargeReq['transaction'];
    order = TapChargeReq['order'];
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

  Receipt.fromJson(Map<String, dynamic> TapChargeReq) {
    email = TapChargeReq['email'];
    sms = TapChargeReq['sms'];
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

  Customer.fromJson(Map<String, dynamic> TapChargeReq) {
    firstName = TapChargeReq['first_name'];
    middleName = TapChargeReq['middle_name'];
    lastName = TapChargeReq['last_name'];
    email = TapChargeReq['email'];
    phone = TapChargeReq['phone'] != null
        ? Phone?.fromJson(TapChargeReq['phone'])
        : null;
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

  Phone.fromJson(Map<String, dynamic> TapChargeReq) {
    countryCode = TapChargeReq['country_code'];
    number = TapChargeReq['number'];
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

  Source.fromJson(Map<String, dynamic> TapChargeReq) {
    id = TapChargeReq['id'];
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

  Post.fromJson(Map<String, dynamic> TapChargeReq) {
    url = TapChargeReq['url'];
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

  Metadata.fromJson(Map<String, dynamic> TapChargeReq) {
    udf1 = TapChargeReq['udf1'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['udf1'] = udf1;
    return data;
  }
}
