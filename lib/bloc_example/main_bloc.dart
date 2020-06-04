import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginwithwordpressapp/bloc_example/bloc/login_bloc.dart';
import 'package:loginwithwordpressapp/bloc_example/bloc/login_event.dart';
import 'package:loginwithwordpressapp/bloc_example/bloc/login_state.dart';
import 'package:loginwithwordpressapp/home_page.dart';
import 'package:loginwithwordpressapp/scroll_expandede_container.dart';
import 'package:loginwithwordpressapp/user_repository.dart';

class BlocApp extends StatelessWidget {
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
        '/home': (_) => HomePage(
              userRepository: UserRepository.instance,
              onLogout: () async {
                await UserRepository.instance.clear();
                Navigator.of(context).pushNamed('/');
              },
            ),
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
  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _bloc = LoginBloc(
      userRepository: UserRepository.instance,
    );

    _bloc.add(AppInitEvent());
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
      body: BlocListener(
        bloc: _bloc,
        listener: (BuildContext context, BaseLoginState state) {
          if (state is ErrorLoginState) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
          }
          if (state is LoggedInState) {
            Navigator.of(context).pushNamed('/home');
          }
        },
        child: BlocBuilder<LoginBloc, BaseLoginState>(
            bloc: _bloc,
            builder: (BuildContext context, BaseLoginState state) {
              return Form(
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
                    if (state is LoadingLoginState)
                      CircularProgressIndicator()
                    else
                      RaisedButton(
                        onPressed: () {
                          var email = _emailController.text;
                          var password = _passwordController.text;

                          var event = DoLoginEvent(email, password);

                          _bloc.add(event);
                        },
                        child: Text("Log in"),
                      ),
                    Spacer(),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
