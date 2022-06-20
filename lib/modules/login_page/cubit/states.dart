abstract class LoginPageStates {}

class LoginPageInitialState extends LoginPageStates {}

class LoginPageChangePasswordVisibilityState extends LoginPageStates {}

class LoginLoadingState extends LoginPageStates{}

class LoginSuccessState extends LoginPageStates{
  LoginSuccessState({required this.uId});
  final String uId ;
}

class LoginErrorState extends LoginPageStates{
  LoginErrorState({required this.error});
  final String error ;
}