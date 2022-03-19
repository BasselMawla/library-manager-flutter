import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const baseUrl = 'https://mobile-library-api.herokuapp.com/';

Future<Map> getAllBooks() async {
  var url = Uri.parse(baseUrl + 'books');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': token,
  });

  Map books = jsonDecode(response.body);

  return books;
}

Future<String> getJwtToken() async {
  final savedPrefs = await SharedPreferences.getInstance();
  final String? token = savedPrefs.getString('jwt');

  if(token == null) {
    return '';
  }
  return token;
}

Future<String> login(String username, String password) async {
  var url = Uri.parse(baseUrl + 'accounts');
  final token = await getJwtToken();

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': token,
      'username': username,
      'password': password,
    },
  );

  Map body = jsonDecode(response.body);
  String bearerToken = body['jwt'];

  // Returns null if login failed
  return bearerToken;
}
