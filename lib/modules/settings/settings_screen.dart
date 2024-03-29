import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/modules/edit_profile/edit_profile_page.dart';
import 'package:social_app/modules/login_page/login_page.dart';
import 'package:social_app/shared/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SignOutSuccessState) {
          navigateAndFinish(context, LoginPage());
        }
      },
      builder: (context, state) {
        var userModel = AppCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: state is AppGetUserLoadingState
              ? Center(
                  child: CircularProgressIndicator(
                    color: secondColor,
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 180.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                              height: 140.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    4.0,
                                  ),
                                  topRight: Radius.circular(
                                    4.0,
                                  ),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    '${userModel!.cover}',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 65.0,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                '${userModel.image}',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${userModel.name}',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '${userModel.bio}',
                      style: TextStyle(
                        color: secondColor,
                        height: 1.0,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              navigateTo(context, const EditProfilePage());
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.edit,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'Edit Profile',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              AppCubit.get(context).signOut();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.logout,
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  'Log Out',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}
