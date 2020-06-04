import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:loginwithwordpressapp/home_page.dart';
import 'package:loginwithwordpressapp/scroll_expandede_container.dart';
import 'package:loginwithwordpressapp/user_repository.dart';

class HooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  Navigator.of(context).pushNamed('/');
                },
              ),
            ),
      },
    );
  }
}

final GlobalKey _formKey = GlobalKey();
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class LoginPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = useTextEditingController();
    TextEditingController _passwordController = useTextEditingController();
    var loading = useState<bool>(true);
    var loggedInFuture =
        useMemoized(() => UserRepository.instance.checkCurrentUser());
    var isLoggedIn = useFuture(loggedInFuture);

    if (isLoggedIn.connectionState == ConnectionState.done) {
      if (UserRepository.instance.currentUser != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushNamed('/home');
        });
      } else {
        loading.value = false;
      }
    }

    return Scaffold(
      key: _scaffoldKey,
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
            if (loading.value)
              CircularProgressIndicator()
            else
              RaisedButton(
                onPressed: () async {
                  var email = _emailController.text;
                  var password = _passwordController.text;
                  // TODO: Login
                  print(email);
                  loading.value = true;

                  var repo = UserRepository.instance;
                  try {
                    await repo.authenticate(email, password);
                    if (repo.currentUser != null) {
                      Navigator.of(context).pushNamed('/home');
                    }
                  } catch (e) {
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                  loading.value = false;
                },
                child: Text("Log in"),
              ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
