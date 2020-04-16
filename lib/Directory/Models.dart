import 'package:firebase_database/firebase_database.dart';
import 'dart:async' show Future;

class DirectoryList{
  List<DirectoryItems> directoryList;
  DirectoryList({this.directoryList});

  factory DirectoryList.fromJSON(Map<dynamic,dynamic> json){
    print('Hi3');
    return DirectoryList(
        directoryList: parseitems(json)
    );

  }

  static List<DirectoryItems> parseitems(json){
    print('Hi4');
    print(json);

    var rList=json['Directory'] as List;
    print('hi $rList');
    print('Hi5');

    List<DirectoryItems> directoryList= rList.map((data) => DirectoryItems.fromJson(data)).toList();
    print('Hi6');
    return directoryList;
  }

}

class DirectoryItems{
  String itemName;
  DirectoryItems({this.itemName});

  factory DirectoryItems.fromJson(Map<dynamic,dynamic> parsedJson) {
    print('Hi8');
    print(parsedJson);
    print('Hi9');
    return DirectoryItems(itemName:parsedJson['Acads']);
  }
}



class MakeCall{
  List<DirectoryItems> listItems=[];
// ListItem recipeModelList=new ListItem();

  Future<List<DirectoryItems>> firebaseCalls (DatabaseReference databaseReference) async{
    print('Hi1');
    DirectoryList directoryList1;

// or
    DataSnapshot dataSnapshot = await databaseReference.once();

    print(dataSnapshot.value['Directory']);
    Map<dynamic,dynamic> jsonResponse=dataSnapshot.value['Directory'];
    print('Hi2');
    directoryList1 = new DirectoryList.fromJSON(jsonResponse);
    print(directoryList1);
    print('Hi7');

    listItems.addAll(directoryList1.directoryList);
//        for(var i in recipeList.recipeList){
//          listItems.addAll(recipeList.recipeList);
//        }
//        print(recipeList.recipeList[1].foodtitle);
    print('That ${listItems[0].itemName}');
//        return recipeList.recipeList;
    return listItems;
  }
}

