import 'package:campusbuddy/search_feature/model.dart';
import 'package:http/http.dart' as http;

List<Contact> contactList = [];

void loadData() async {
  var url = Uri.parse(
      'https://raw.githubusercontent.com/mdg-iitr/CampusBuddy/master/app/src/main/assets/contacts.min.json');
  var response = await http.get(url);
  final jsonResponse = groupsFromJson(response.body);
  for (int i = 0; i < jsonResponse.length; i++) {
    List<Department> departmentList = jsonResponse[i].depts;
    for (int j = 0; j < departmentList.length; j++) {
      for (int k = 0; k < departmentList[j].contacts.length; k++) {
        departmentList[j].contacts[k].department_name =
            departmentList[j].deptName;
      }
      contactList = contactList + departmentList[j].contacts;
    }
  }
  print('data loaded');
}