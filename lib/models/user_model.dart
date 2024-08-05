
import 'package:flutter/cupertino.dart';

class UserModel {
   String? fullName;
   String? username;
   String? rating;
   String? email;
   String? number;
   double? balance;
   String? createdAt;
   String? updatedAt;
   String? uid;
   String? userType;


  UserModel({
    this.uid,
    this.fullName,
    this.username,
    this.email,
    this.number,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.userType,
    this.rating,
  });

  // receiving data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      number: map['number'],
      fullName: map['fullName'],
      username: map['username'],
      balance: map['balance'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      userType: map['userType'],
      rating: map['rating'],
    );
  }


  // sending data to the server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'number': number,
      'fullName': fullName,
      'username': username,
      'balance': balance,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userType': userType,
      'rating': rating,

    };
  }
}