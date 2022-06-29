import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/app_layout.dart';
import 'package:social_app/layouts/cubit/cubit.dart';

import 'package:social_app/modules/signup_page/cubit/cubit.dart';
import 'package:social_app/modules/signup_page/cubit/states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/custom_text_form_field.dart';

import '../../network/cache_helper.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupPageStates>(
      listener: (context, state) {
        if (state is SignUpErrorState) {
          showToast(
            state.error,
            ToastState.error,
          );
        }

        if (state is SignUpSuccessState) {
          CacheHelper.putData(
            key: 'uId',
            value: state.uId,
          ).then((value) {
            AppCubit.get(context).getUserData().then((value) {
              navigateAndFinish(context, AppLayout());
            });
          });
        }
      },
      builder: (context, state) {
        var cubit = SignupCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: mainColor,
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      const Text(
                        "Sign Up now to join our social network",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 32.0,
                      ),
                      CustomTextFormField(
                        controller: nameController,
                        obscure: false,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Username can\'t be empty";
                          }
                        },
                        prefix: Icons.person,
                        label: "User Name",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomTextFormField(
                        controller: mailController,
                        obscure: false,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Email can\'t be empty";
                          }
                        },
                        prefix: Icons.mail,
                        label: "Email",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomTextFormField(
                        controller: passwordController,
                        obscure: cubit.isPassword,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "Password can\'t be empty";
                          }
                        },
                        prefix: Icons.lock,
                        label: "Password",
                        suffix: cubit.isPassword
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_rounded,
                        suffixPressed: () {
                          cubit.changePasswordVisibility();
                        },
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      CustomTextFormField(
                        controller: phoneController,
                        obscure: false,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            return "phone can\'t be empty";
                          }
                        },
                        prefix: Icons.phone,
                        label: "Phone Number",
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48.0,
                        child: MaterialButton(
                          onPressed: () {
                            cubit.registerUser(
                              name: nameController.text,
                              email: mailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                            );
                          },
                          color: mainColor,
                          child: state is SignUpLoadingState
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Sign up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                    fontSize: 20.0,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          const Text("Already have an account? "),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
