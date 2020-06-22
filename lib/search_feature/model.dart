import 'package:flutter/material.dart';
import 'dart:convert';

List<Group> groupsFromJson(String str) => List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

String groupsToJson(List<Group> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Group
{
   String groupName;
   int id;
   List<Department> depts;

   Group({
     this.groupName,
     this.id,
     this.depts
    });

   factory Group.fromJson(Map<String, dynamic> json) => Group(
     groupName: json["group_name"],
     id: json["id"],
     depts: List<Department>.from(json["depts"].map((x) => Department.fromJson(x))),
   );

   Map<String, dynamic> toJson() => {
     "group_name": groupName,
     "id": id,
     "depts": List<dynamic>.from(depts.map((x) => x.toJson())),
   };
}

class Department {
  Department({
    this.contacts,
    this.id,
    this.deptName,
  });

  List<Contact> contacts;
  int id;
  String deptNameHindi;
  String deptName;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    contacts: List<Contact>.from(json["contacts"].map((x) => Contact.fromJson(x))),
    id: json["id"],
    deptName: json["dept_name"],
  );

  Map<String, dynamic> toJson() => {
    "contacts": List<dynamic>.from(contacts.map((x) => x.toJson())),
    "id": id,
    "dept_name": deptName,
  };
}

class Contact {
  Contact({
    this.email,
    this.bsnlRes,
    this.id,
    this.iitrR,
    this.desg,
    this.name,
    this.iitrO,
    this.mobile,
    this.address,
    this.department_name
  });

  List<String> email;
  List<String> bsnlRes;
  int id;
  List<String> iitrR;
  String desg;
  String name;
  List<String> iitrO;
  List<String> mobile;
  String address;
  String department_name;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
    email: json["email"] == null ? null : List<String>.from(json["email"].map((x) => x)),
    bsnlRes: json["bsnl_res"] == null ? null : List<String>.from(json["bsnl_res"].map((x) => x)),
    id: json["id"],
    iitrR: json["iitr_r"] == null ? null : List<String>.from(json["iitr_r"].map((x) => x)),
    desg: json["desg"] == null ? null : json["desg"],
    name: json["name"],
    iitrO: json["iitr_o"] == null ? null : List<String>.from(json["iitr_o"].map((x) => x)),
    mobile: json["mobile"] == null ? null : List<String>.from(json["mobile"].map((x) => x)),
    address: json["address"] == null ? null : json["address"],
  );

  Map<String, dynamic> toJson() => {
    "email": email == null ? null : List<dynamic>.from(email.map((x) => x)),
    "bsnl_res": bsnlRes == null ? null : List<dynamic>.from(bsnlRes.map((x) => x)),
    "id": id,
    "iitr_r": iitrR == null ? null : List<dynamic>.from(iitrR.map((x) => x)),
    "desg": desg == null ? null : desg,
    "name": name,
    "iitr_o": iitrO == null ? null : List<dynamic>.from(iitrO.map((x) => x)),
    "mobile": mobile == null ? null : List<dynamic>.from(mobile.map((x) => x)),
    "address": address == null ? null : address,
  };
}

