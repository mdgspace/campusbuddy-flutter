import 'package:firebase_database/firebase_database.dart';
class ContactListElement{
  String name;
  String sub;
  String phno1;
  String phno2;
  String email;
  ContactListElement({this.name,this.sub,this.email,this.phno1,this.phno2});
  factory ContactListElement.fromJson(Map<dynamic,dynamic> parsedJson){
    return ContactListElement(name: parsedJson['name'],sub: parsedJson['sub'],email: parsedJson['email'],phno1: parsedJson['contact1'],phno2: parsedJson['contact2']);

  }
}

class ContactList{
  List<ContactListElement> contactList;
  ContactList({this.contactList});
  factory ContactList.fromJSON(Map<dynamic,dynamic> json){
    return ContactList(
      contactList: parsecontact(json)
    );
  }
  static List<ContactListElement> parsecontact(contactJSON){
    var rList=contactJSON['contact'] as List;
    List<ContactListElement> contactList=rList.map((e) => ContactListElement.fromJson(e)).toList();
    return contactList;
  }
}

class MakeCall{
  List<ContactListElement> listitems=[];
  Future<List<ContactListElement>> firebaseCalls (DatabaseReference databaseReference) async {
    ContactList contactList;
    DataSnapshot dataSnapshot = await databaseReference.once();
    Map<dynamic,dynamic> jsonResponse=dataSnapshot.value['ContactList'];
    contactList=new ContactList.fromJSON(jsonResponse);
    listitems.addAll(contactList.contactList);
    return listitems;
  }
}