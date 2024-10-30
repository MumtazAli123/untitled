

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
   String? image;
   String? address;
   String? city;


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
    this.image,
    this.address,
    this.city,

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
      image: map['image'],
      address: map['address'],
      city: map['city'],
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
      'image': image,
      'address': address,
      'city': city,

    };
  }
}


class UserItem {
  String? accessToken;
  String? token;
  String? name;
  String? description;
  String? avatar;
  int? online;
  int? type;

  UserItem({
    this.accessToken,
    this.token,
    this.name,
    this.description,
    this.avatar,
    this.online,
    this.type,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) =>
      UserItem(
        accessToken: json["accessToken"],
        token: json["token"],
        name: json["name"],
        description: json["description"],
        avatar: json["avatar"],
        online: json["online"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "token": token,
    "name": name,
    "description": description,
    "avatar": avatar,
    "online": online,
    "type": type,
  };
}