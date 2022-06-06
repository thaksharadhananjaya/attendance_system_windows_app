import 'dart:convert';


import 'package:attended/models/guest_model.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class GuestRepo {
  Future<List<Guest>> getGuest(
      int isAttend, int page, String search) async {
    //print(page);
    try {
      String path = "$url/get_guest.php";

      var response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "page": "$page",
      });
      if (search != null) {
        response = await http.post(Uri.parse(path),
            body: {"key": accessKey, "page": "$page", "search": search});
      }

      if (isAttend!=0) {
        response = await http.post(Uri.parse(path),
            body: {"key": accessKey, "page": "$page", "isAttend": "$isAttend"});
      }

 
      List<dynamic> list = jsonDecode(response.body);

      List<Guest> postList = [];

      list.map((data) => postList.add(Guest.fromJson(data))).toList();

      return postList.isEmpty ? null : postList;
    } catch (e) {
      print("Error"+ e.toString());
      return null;
    }
  }
}
