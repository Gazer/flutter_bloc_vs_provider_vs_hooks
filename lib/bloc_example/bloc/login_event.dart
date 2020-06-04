
abstract class LoginEvent {

}

class AppInitEvent extends LoginEvent {}

class DoLoginEvent extends LoginEvent {
  final String email;
  final String password;

  DoLoginEvent(this.email, this.password);
}