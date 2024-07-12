import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<Map<String, String?>> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'phone': prefs.getString('phone'),
      'imageUrl': prefs.getString('imageUrl'),
    };
  }

  Future<void> saveUserDataToSharedPreferences(String name, String email, String phone, String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('phone', phone);
    prefs.setString('imageUrl', imageUrl);
  }
}
