import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loginwithwordpressapp/home_page.dart';
import 'package:loginwithwordpressapp/mobx_example/login_store.dart';
import 'package:loginwithwordpressapp/scroll_expandede_container.dart';
import 'package:loginwithwordpressapp/user_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class MobxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => LoginStore(UserRepository.instance),
      builder: (BuildContext context, Widget child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LoginPage(),
          routes: {
            '/home': (_) => Builder(
                  builder: (BuildContext context) => HomePage(
                    userRepository: UserRepository.instance,
                    onLogout: () async {
                      await UserRepository.instance.clear();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                ),
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
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  LoginStore _store;
  List<ReactionDisposer> _disposer = List();

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
    if (_disposer != null) {
      _disposer.forEach((d) => d.call());
    }

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_store == null) {
      _store = Provider.of<LoginStore>(context);
      _store.checkLogin();
    }

    _disposer.addAll([
      when(
        (_) => _store.errorMessage != null,
        () {
          _scaffoldState.currentState.showSnackBar(
            SnackBar(
              content: Text(_store.errorMessage),
            ),
          );
        },
      ),
      when(
        (_) => _store.isLogged,
        () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
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
            Observer(builder: (_) {
              if (_store.isLoading) {
                return CircularProgressIndicator();
              } else {
                return RaisedButton(
                  onPressed: () {
                    var email = _emailController.text;
                    var password = _passwordController.text;

                    // Do login
                    _store.login(email, password);
                  },
                  child: Text("Log in"),
                );
              }
            }),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
