import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/custom_text_form_field.dart';
import 'package:social_app/shared/icon_broken.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is PickProfileImageErrorState) {
          showToast(
            state.error,
            ToastState.error,
          );
        }
        if (state is PickCoverImageErrorState) {
          showToast(
            state.error,
            ToastState.error,
          );
        }
        if (state is UserUpdateSuccessState) {
          showToast('User Updated Successfully', ToastState.success);
          Navigator.of(context).pop();
        }
        if (state is UserUpdateErrorState) {
          showToast(
            state.error,
            ToastState.error,
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        var userModel = AppCubit.get(context).userModel;

        var profileImage = cubit.profileImage;
        var coverImage = cubit.coverImage;

        final TextEditingController bioController = TextEditingController();
        final TextEditingController phoneController = TextEditingController();
        final TextEditingController nameController = TextEditingController();

        bioController.text = userModel!.bio!;
        nameController.text = userModel.name!;
        phoneController.text = userModel.phone!;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                cubit.removeProfileImage();
                cubit.removeCoverImage();
                Navigator.of(context).pop();
              },
              icon: Icon(
                IconBroken.Arrow___Left_2,
                color: secondColor,
              ),
            ),
            titleSpacing: 5.0,
            title: Text(
              'Edit Profile ',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is UploadImageLoadingState)
                    LinearProgressIndicator(
                      color: secondColor,
                    ),
                  if (state is UploadImageLoadingState)
                    const SizedBox(
                      height: 8.0,
                    ),
                  SizedBox(
                    height: 180.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
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
                                  image: coverImage != null
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(coverImage),
                                        )
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            '${userModel.cover}',
                                          ),
                                        ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.pickCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 65.0,
                              backgroundColor: Colors.white,
                              child: profileImage != null
                                  ? CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: FileImage(profileImage),
                                    )
                                  : CircleAvatar(
                                      radius: 60.0,
                                      backgroundImage: NetworkImage(
                                        '${userModel.image}',
                                      ),
                                    ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.pickProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  CustomTextFormField(
                    controller: nameController,
                    obscure: false,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'Username can\'t be empty';
                      }
                    },
                    prefix: IconBroken.User1,
                    label: 'User Name',
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  CustomTextFormField(
                    controller: phoneController,
                    obscure: false,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'Phone can\'t be empty';
                      }
                    },
                    prefix: IconBroken.Call,
                    label: 'Phone',
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  CustomTextFormField(
                    controller: bioController,
                    obscure: false,
                    validate: (String? value) {
                      if (value!.isEmpty) {
                        return 'Bio can\'t be empty';
                      }
                    },
                    prefix: IconBroken.Info_Circle,
                    label: 'Bio',
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: MaterialButton(
                      onPressed: state is! UploadImageLoadingState
                          ? () {
                              cubit.updateUser(
                                name: nameController.text,
                                phone: phoneController.text,
                                bio: bioController.text,
                              );
                            }
                          : null,
                      color: state is! UploadImageLoadingState
                          ? mainColor
                          : Colors.grey,
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
