import 'package:firebase_database/firebase_database.dart';
class ContactListElement{
  String name;
  String sub;
  String office;
  String residence;
  String email;
  ContactListElement({this.name,this.sub,this.email,this.office,this.residence});
  factory ContactListElement.fromJson(Map<dynamic,dynamic> parsedJson){
    return ContactListElement(name: parsedJson['name'],sub: parsedJson['sub'],email: parsedJson['email'],office: parsedJson['office'],residence: parsedJson['residence']);

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