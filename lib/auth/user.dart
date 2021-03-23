// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

MyUser userFromJson(String str) => MyUser.fromJson(json.decode(str));

String userToJson(MyUser data) => json.encode(data.toJson());

class MyUser {
  String id;
  String email;

  MyUser(
      {
        this.id,
        this.email,
      });

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
      id: json["id"],
      email: json["email"],
     );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,

  };
}
