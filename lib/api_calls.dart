import 'dart:convert';

import 'package:cem7052_library/utils.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://mobile-library-api.herokuapp.com/';

Future<Map> getAllBooks() async {
  var url = Uri.parse(baseUrl + 'books');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ' + token,
  });

  Map books = jsonDecode(response.body);

  return books;
}

Future<Map> getAllStudents() async {
  var url = Uri.parse(baseUrl + 'students');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ' + token,
  });

  Map books = jsonDecode(response.body);

  return books;
}

Future<void> login(String username, String password) async {
  var url = Uri.parse(baseUrl + 'accounts');

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'username': username,
      'password': password,
    },
  );

  Map body = jsonDecode(response.body);
  String token = body['jwt'];
  bool isLibrarian = body['is_librarian'] == 1 ? true : false;

  await setJwtToken(token);
  await setIsLibrarian(isLibrarian);
}

Future<bool> addBook(Map<String, dynamic> bookInfo) async {
  var url = Uri.parse(baseUrl + 'books');
  final token = await getJwtToken();

  final response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token,
    },
    body: jsonEncode(bookInfo),
  );

  if(response.statusCode == 204) {
    return true;
  }
  return false;
}
