import 'package:loginwithwordpressapp/user_repository.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  final UserRepository userRepository;

  _LoginStore(this.userRepository);

  @observable
  bool isLoading = false;

  @observable
  bool isLogged = false;

  @observable
  String errorMessage;

  @action
  Future checkLogin() async {
    isLoading = true;
    await userRepository.checkCurrentUser();
    isLogged = userRepository.currentUser != null;
    isLoading = false;
  }

  @action
  Future login(String email, String password) async {
    isLoading = true;
    errorMessage = null;
    try {
      await userRepository.authenticate(email, password);
      isLogged = userRepository.currentUser != null;
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
  }
}
