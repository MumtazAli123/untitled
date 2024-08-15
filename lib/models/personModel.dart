import 'package:cloud_firestore/cloud_firestore.dart';

class PersonModel {
  String? uid;
  String? name;
  String? age;
  String? image;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? country;
  String? lookingForPartner;
  String? lookingForJob;
  String? publishedDate;

  // life style
  String? smoking;
  String? drinking;
  String? diet;
  String? height;
  String? weight;
  String? income;
  String? education;
  String? profession;
  String? maritalStatus;

  // background culture values
  String? nationality;
  String? language;
  String? religion;
  String? caste;

  PersonModel({
    this.uid,
    this.name,
    this.age,
    this.image,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.lookingForPartner,
    this.lookingForJob,
    this.publishedDate,
    this.smoking,
    this.drinking,
    this.diet,
    this.height,
    this.weight,
    this.income,
    this.education,
    this.profession,
    this.maritalStatus,
  });

  static PersonModel fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnap = snapshot.data() as Map<String, dynamic>;
    return PersonModel(
      uid: snapshot['uid'],
      name: dataSnap['name'],
      age: dataSnap['age'],
      image: dataSnap['image'],
      email: dataSnap['email'],
      phone: dataSnap['phone'],
      address: dataSnap['address'],
      city: dataSnap['city'],
      country: dataSnap['country'],
      lookingForPartner: dataSnap['lookingForPartner'],
      lookingForJob: dataSnap['lookingForJob'],
      publishedDate: dataSnap['publishedDate'],
      smoking: dataSnap['smoking'],
      drinking: dataSnap['drinking'],
      diet: dataSnap['diet'],
      height: dataSnap['height'],
      weight: dataSnap['weight'],
      income: dataSnap['income'],
      education: dataSnap['education'],
      profession: dataSnap['profession'],
      maritalStatus: dataSnap['maritalStatus'],
    );
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      uid: json['uid'],
      name: json['name'],
      age: json['age'],
      image: json['image'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      lookingForPartner: json['lookingForPartner'],
      lookingForJob: json['lookingForJob'],
      publishedDate: json['publishedDate'],
      smoking: json['smoking'],
      drinking: json['drinking'],
      diet: json['diet'],
      height: json['height'],
      weight: json['weight'],
      income: json['income'],
      education: json['education'],
      profession: json['profession'],
      maritalStatus: json['maritalStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'age': age,
      'image': image,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'lookingForPartner': lookingForPartner,
      'lookingForJob': lookingForJob,
      'publishedDate': publishedDate,
      'smoking': smoking,
      'drinking': drinking,
      'diet': diet,
      'height': height,
      'weight': weight,
      'income': income,
      'education': education,
      'profession': profession,
      'maritalStatus': maritalStatus,
    };
  }
}
