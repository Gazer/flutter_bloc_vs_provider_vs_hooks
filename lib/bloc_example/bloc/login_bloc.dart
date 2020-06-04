import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginwithwordpressapp/bloc_example/bloc/login_state.dart';
import 'package:loginwithwordpressapp/user_repository.dart';

import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, BaseLoginState> {
  final UserRepository userRepository;

  LoginBloc({@required this.userRepository});

  @override
  BaseLoginState get initialState => InitialLoginState();

  @override
  Stream<BaseLoginState> mapEventToState(LoginEvent event) async* {
    if (event is AppInitEvent) {
      yield LoadingLoginState();

      await userRepository.checkCurrentUser();

      if (userRepository.currentUser == null) {
        yield InitialLoginState();
      } else {
        yield LoggedInState();
      }
    }

    if (event is DoLoginEvent) {
      yield LoadingLoginState();

      try {
        // Do login
        await userRepository.authenticate(event.email, event.password);

        // Change screen
        yield LoggedInState();
      } catch (error) {
        yield ErrorLoginState(error.toString());
      }
    }
  }
}
