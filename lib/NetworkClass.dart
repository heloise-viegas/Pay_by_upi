import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zpay_by_upi/Contact.dart';

class NetworkClass {
  static const url = 'https://fakeface.rest/face/json';
  Contact _contact = Contact();

  Future<Contact> getContact() async {
    Uri request = Uri.parse(url);
    http.Response response = await http.get(request);
    if (response.statusCode == 200) {
      _contact = Contact.fromJson(jsonDecode(response.body));
      print(response.statusCode);
      return _contact;
    } else {
      print(response.statusCode);

      throw 'Problem with the get request';
    }
  }
}
