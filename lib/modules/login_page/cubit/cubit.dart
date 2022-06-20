import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login_page/cubit/states.dart';

class LoginCubit extends Cubit<LoginPageStates> {
  LoginCubit() : super(LoginPageInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(LoginPageChangePasswordVisibilityState());
  }

  void userLogin({required String email, required String password}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
          emit(LoginSuccessState(uId: value.user!.uid));
    })
        .catchError((error) {
      emit(LoginErrorState(error: error.toString()));
    });
  }
}
