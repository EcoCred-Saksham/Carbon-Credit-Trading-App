// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  String name;
  String walletId;
  User({
    required this.name,
    required this.walletId,
  });
  

  User copyWith({
    String? name,
    String? walletId,
  }) {
    return User(
      name: name ?? this.name,
      walletId: walletId ?? this.walletId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'walletId': walletId,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ,
      walletId: map['walletId'] ,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'User(name: $name, walletId: $walletId)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.walletId == walletId;
  }

  @override
  int get hashCode => name.hashCode ^ walletId.hashCode;
}
class AppKeys{
    static final regis = const Key('Regis');
  static final login = const Key('Login');
  static final wallet = const Key('Wallet');
    static final Ad = const Key('Ad');


}
class ShowAd {
  String? walletId;
  String? name;
  int? rate;
  int? noOfCredits;

  ShowAd({this.walletId, this.name, this.rate, this.noOfCredits});

  ShowAd.fromJson(Map<String, dynamic> json) {
    walletId = json['wallet_id'];
    name = json['name'];
    rate = json['rate'];
    noOfCredits = json['no_of_credits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_id'] = this.walletId;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['no_of_credits'] = this.noOfCredits;
    return data;
  }
}