
abstract class BaseLoginState {

}

class InitialLoginState extends BaseLoginState {}

class LoadingLoginState extends BaseLoginState {}

class LoggedInState extends BaseLoginState {}

class ErrorLoginState extends BaseLoginState {
  final String message;

  ErrorLoginState(this.message);
}