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

Future<bool> getIsLoggedIn() async {
  final savedPrefs = await SharedPreferences.getInstance();
  try {
    final bool? isLoggedIn = savedPrefs.getBool('isLoggedIn');
    if (isLoggedIn == null) {
      return false;
    }
    return isLoggedIn;
  } catch (e) {
    return false;
  }
}

Future<void> setIsLoggedIn(bool isLoggedIn) async {
  final savedPrefs = await SharedPreferences.getInstance();
  savedPrefs.setBool('isLoggedIn', isLoggedIn);
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