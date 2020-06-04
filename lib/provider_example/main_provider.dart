import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loginwithwordpressapp/home_page.dart';
import 'package:loginwithwordpressapp/provider_example/login_provider.dart';
import 'package:loginwithwordpressapp/scroll_expandede_container.dart';
import 'package:loginwithwordpressapp/user_repository.dart';
import 'package:provider/provider.dart';

class ProviderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(UserRepository.instance),
      builder: (BuildContext context, Widget child) {
        return Selector<LoginProvider, bool>(
          selector: (_, LoginProvider loginProvider) =>
              loginProvider.isLoggedIn,
          builder: (BuildContext context, bool isLoggedIn, _) {
            Widget home;
            if (isLoggedIn) {
              home = HomePage(
                userRepository: UserRepository.instance,
                onLogout: () {
                  Provider.of<LoginProvider>(context, listen: false).logout();
                },
              );
            } else {
              home = LoginPage();
            }

            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: home,
            );
          },
        );
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = GlobalKey();
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ScrollExpandContainer(
          children: <Widget>[
            Image.asset('assets/logo.png'),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: "Password"),
              ),
            ),
            Spacer(),
            Consumer<LoginProvider>(
              builder: (BuildContext context, LoginProvider loginProvider,
                  Widget child) {
                if (loginProvider.isLoading) {
                  return CircularProgressIndicator();
                }
                return child;
              },
              child: RaisedButton(
                onPressed: () {},
                child: Text("Log in"),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _showError(BuildContext context, String lastError) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(lastError)),
    );
  }
}
