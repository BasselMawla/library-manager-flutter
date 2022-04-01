import 'package:shared_preferences/shared_preferences.dart';

//bool _isLibrarian = false;

Future<String> getJwtToken() async {
  final savedPrefs = await SharedPreferences.getInstance();
  try {
    final String? token = savedPrefs.getString('jwt');
    if (token == null) {
      return '';
    }
    return token;
  } catch (e) {
    return '';
  }
}

Future<void> setJwtToken(String token) async {
  final savedPrefs = await SharedPreferences.getInstance();
  savedPrefs.setString('jwt', token);
}

Future<String> getUsername() async {
  final savedPrefs = await SharedPreferences.getInstance();
  try {
    final String? username = savedPrefs.getString('username');
    if (username == null) {
      return '';
    }
    return username;
  } catch (e) {
    return '';
  }
}

Future<void> setUsername(String username) async {
  final savedPrefs = await SharedPreferences.getInstance();
  savedPrefs.setString('username', username);
}

Future<bool> getIsLibrarian() async {
  final savedPrefs = await SharedPreferences.getInstance();
  try {
    final bool? isLibrarian = savedPrefs.getBool('isLibrarian');
    if (isLibrarian == null) {
      return false;
    }
    return isLibrarian;
  } catch (e) {
    return false;
  }
}

Future<void> setIsLibrarian(bool isLibrarian) async {
  final savedPrefs = await SharedPreferences.getInstance();
  savedPrefs.setBool('isLibrarian', isLibrarian);
}

Future<Map> getUserInfo() async {
  String username = await getUsername();
  bool isLibrarian = await getIsLibrarian();

  return {'username': username, 'isLibrarian': isLibrarian};
}

Future<void> logOut() async {
  final savedPrefs = await SharedPreferences.getInstance();
  savedPrefs.remove('username');
  savedPrefs.remove('jwt');
  savedPrefs.setBool('isLibrarian', false);
}