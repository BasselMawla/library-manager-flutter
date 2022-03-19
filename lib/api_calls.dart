import 'dart:convert';

import 'package:http/http.dart' as http;

const baseUrl = 'https://mobile-library-api.herokuapp.com/';
const token =
    'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE2NDc2MTY1MzIsInN1YiI6IjI4IiwiaXNzIjoiaHR0cHM6Ly9tb2JpbGUtbGlicmFyeS1hcGkuaGVyb2t1YXBwLmNvbS8ifQ.Y9D_0F7GyNv1fbUvDb8QSfkBQU4qupRODntNnKRuuwo';

Future<Map> getAllBooks() async {
  var url = Uri.parse(baseUrl + 'books');
  final response = await http.get(url, headers: {
    'Accept': 'application/json',
    'authorization': token,
  });

  Map books = jsonDecode(response.body);

  return books;
}
