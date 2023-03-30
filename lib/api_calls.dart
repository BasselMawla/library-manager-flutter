import 'dart:convert';

import 'package:library_manager/utils.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'https://library-manager-rest-api.herokuapp.com';

Future<Map> getAllBooks() async {
  var url = Uri.parse('$baseUrl/books');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ' + token,
  });

  Map books = jsonDecode(response.body);

  return books;
}

Future<Map> searchBooks(String searchQuery) async {
  var url = Uri.parse('$baseUrl/books?q=$searchQuery');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ' + token,
  });

  Map books = jsonDecode(response.body);

  return books;
}

Future<Map> getAllStudents() async {
  var url = Uri.parse('$baseUrl/students');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ' + token,
  });

  return jsonDecode(response.body);
}

Future<int> login(String username, String password) async {
  var url = Uri.parse('$baseUrl/accounts');

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'username': username,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    Map body = jsonDecode(response.body);
    String token = body['jwt'];
    bool isLibrarian = body['is_librarian'] == 1 ? true : false;

    await setJwtToken(token);
    await setUsername(username);
    await setIsLibrarian(isLibrarian);
    return 200;
  } else {
    return response.statusCode;
  }
}

Future<bool> addBook(Map<String, dynamic> bookInfo) async {
  var url = Uri.parse('$baseUrl/books');
  final token = await getJwtToken();

  final response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token,
    },
    body: jsonEncode(bookInfo),
  );

  if (response.statusCode == 204) {
    return true;
  }
  return false;
}

Future<bool> returnBook(String bookId) async {
  var url = Uri.parse('$baseUrl/books/$bookId');
  final token = await getJwtToken();

  final response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token,
    },
  );

  if (response.statusCode == 204) {
    return true;
  }
  return false;
}

Future<int> loanBook(String username, String uuid) async {
  var url = Uri.parse('$baseUrl/students/$username');
  Map<String, dynamic> bodyMap = {'uuid': uuid};

  final token = await getJwtToken();

  final response = await http.post(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + token,
    },
    body: jsonEncode(bodyMap),
  );

  return response.statusCode;
}

Future<Map> getStudentRecord(String username) async {
  var url = Uri.parse('$baseUrl/students/$username');
  final token = await getJwtToken();

  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer ' + token,
  });

  return jsonDecode(response.body);
}
