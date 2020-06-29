// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String id;
  String email;

  User(
      {
        this.id,
        this.email,
      });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      email: json["email"],
     );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,

  };
}
