
import 'package:flutter_wordpress/flutter_wordpress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static UserRepository _instance = UserRepository();
  static UserRepository get instance => _instance;

  WordPress _wordpress = WordPress(
    baseUrl: 'https://gazer.com.ar',
    authenticator: WordPressAuthenticator.JWT,
    adminName: '',
    adminKey: '',
  );

  User currentUser;

  Future<String> authenticate(String username, String password) async {
    currentUser = await _wordpress.authenticateUser(
      username: username,
      password: password,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_wordpress.getToken() != null) {
      print("Token saved");
      prefs.setString("token", _wordpress.getToken());
    }

    return _wordpress.getToken();
  }

  Future<void> checkCurrentUser() async {
    print("Checking current user");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("token")) {
      print("Got Token!");
      var token = prefs.getString("token");
      currentUser = await _wordpress.authenticateViaToken(token);
    }
  }

  Future<void> clear() async {
    currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    _wordpress = WordPress(
      baseUrl: 'https://gazer.com.ar',
      authenticator: WordPressAuthenticator.JWT,
      adminName: '',
      adminKey: '',
    );
  }
}