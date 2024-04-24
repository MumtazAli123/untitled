
class UserModel {
   String? fullName;
   String? username;
   String? email;
   String? number;
   double? balance;
   String? createdAt;
   String? updatedAt;
   String? uid;

  UserModel({
    this.uid,
    this.fullName,
    this.username,
    this.email,
    this.number,
    this.balance,
    this.createdAt,
    this.updatedAt,
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

    };
  }
}