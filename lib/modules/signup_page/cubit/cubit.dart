import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/signup_page/cubit/states.dart';


class SignupCubit extends Cubit<SignupPageStates> {
  SignupCubit() : super(SignupPageInitialState());

  static SignupCubit get(BuildContext context) => BlocProvider.of(context);

  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    emit(SignupPageChangePasswordVisibilityState());
  }

  void registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(SignUpLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      userCreate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );

      emit(SignUpSuccessState(uId: value.user!.uid));
    }).catchError((error) {
      emit(SignUpErrorState(error: error.toString()));
    });
  }

  void userCreate({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    UserModel _userModel = UserModel(
      name: name,
      mail: email,
      image:
          'https://firebasestorage.googleapis.com/v0/b/social-app-c11f0.appspot.com/o/defaults%2Fdefault%20place%20holder.jpg?alt=media&token=f7c6d82b-05a5-4b8c-a8ab-74d177293b13',
      phone: phone,
      bio: 'Enter your bio ... ',
      uId: uId,
      cover:
          'https://firebasestorage.googleapis.com/v0/b/social-app-c11f0.appspot.com/o/defaults%2Fdefault_cover_image.png?alt=media&token=ffaa7e70-024b-447c-a77b-7657e2c65d5c',
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(_userModel.toMap())
        .then((value) {
          emit(CreateUserSuccessState());
    })
        .catchError((error) {
          emit(CreateUserErrorState(error: error.toString()));
    });
  }
}
