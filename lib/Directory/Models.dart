/**import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async' show Future;

class DirectoryList{
  List<DirectoryItems> directoryList;
  DirectoryList({this.directoryList});

  factory DirectoryList.fromJSON(Map<dynamic,dynamic> json){
  //  print('Hi3');
    return DirectoryList(
        directoryList: parseitems(json)
    );

  }

  static List<DirectoryItems> parseitems(json){
   // print('Hi4');
    print(json);
    var rList=json['directory'] as List;
    print('hi $rList');
   // print('Hi5');

    List<DirectoryItems> directoryList= rList.map((data) => DirectoryItems.fromJson(data)).toList();
  //  print('Hi8');
    return directoryList;
  }

}

class DirectoryItems{
  String itemName;
  DirectoryItems({this.itemName});

  factory DirectoryItems.fromJson(Map<dynamic,dynamic> parsedJson) {
    //print('Hi6');
    print(parsedJson);
   // print('Hi7');
    return DirectoryItems(itemName:parsedJson['a']);
  }
}



class MakeCall{
  List<DirectoryItems> listItems=[];

  Future<List<DirectoryItems> > firebaseCalls (DatabaseReference databaseReference) async{
   // print('Hi1');
    DirectoryList directoryList;
    DataSnapshot dataSnapshot = await databaseReference.once();
    print(dataSnapshot.value['Directory']);

    Map<dynamic,dynamic> jsonResponse=dataSnapshot.value['Directory'];
  //  print('Hi2');

    directoryList = new DirectoryList.fromJSON(jsonResponse);
    print(directoryList);
   // print('Hi9');
    listItems.addAll(directoryList.directoryList);

    // print('Hi10');
    return listItems;

  }
}

*/
