import 'package:flutter/material.dart';
import 'package:loginwithwordpressapp/user_repository.dart';

class HomePage extends StatelessWidget {
  final UserRepository userRepository;
  final Function onLogout;

  const HomePage({Key key, this.userRepository, this.onLogout})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Hola ${userRepository.currentUser.name}"),
            RaisedButton(
              onPressed: () async {
                onLogout();
              },
              child: Text("Log out"),
            )
          ],
        ),
      ),
    );
  }
}
