abstract class SignupPageStates {}

class SignupPageInitialState extends SignupPageStates {}

class SignupPageChangePasswordVisibilityState extends SignupPageStates {}

class SignUpSuccessState extends SignupPageStates {
  SignUpSuccessState({required this.uId});

  final String uId;
}

class SignUpLoadingState extends SignupPageStates {}

class SignUpErrorState extends SignupPageStates {
  SignUpErrorState({required this.error});

  final String error;
}

class CreateUserSuccessState extends SignupPageStates {}

class CreateUserErrorState extends SignupPageStates {
  CreateUserErrorState({required this.error});

  final String error;
}
