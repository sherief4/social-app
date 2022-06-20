import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController postController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is CreatePostWithImageSuccessState ||
            state is CreatePostSuccessState) {
          Navigator.of(context).pop();
          AppCubit.get(context).removePostImage();
          showToast('Post created Successfully', ToastState.success);
        }
        if (state is CreatePostErrorState) {
          showToast(state.error, ToastState.error);
        }
        if (state is CreatePostWithImageErrorState) {
          showToast(state.error, ToastState.error);
        }
        if (state is PickPostImageErrorState) {
          showToast(state.error, ToastState.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  AppCubit.get(context).removePostImage();
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  IconBroken.Arrow___Left_2,
                  color: secondColor,
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    if (AppCubit.get(context).postImage != null) {
                      AppCubit.get(context).createPostWithImage(
                          dateTime: DateTime.now().toString(),
                          postText: postController.text);
                    } else {
                      AppCubit.get(context).createPost(
                          dateTime: DateTime.now().toString(),
                          text: postController.text);
                    }
                  },
                  child: Text(
                    'POST',
                    style: TextStyle(
                      color: secondColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ))
            ],
            titleSpacing: 5.0,
            title: Text(
              'Create Post',
              style: TextStyle(
                color: mainColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                if (state is UploadImageLoadingState)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                      color: secondColor,
                    ),
                  ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          '${AppCubit.get(context).userModel!.image}'),
                      radius: 25.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${AppCubit.get(context).userModel!.name}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blueGrey,
                                size: 16.0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: postController,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind ....',
                      border: InputBorder.none,
                    ),
                  ),
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
                            InkWell(
                              onTap: () {
                                AppCubit.get(context).pickPostImage();
                              },
                              child: Container(
                                height: 300.0,
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
                                  image: AppCubit.get(context).postImage != null
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: FileImage(
                                              AppCubit.get(context).postImage!),
                                        )
                                      : const DecorationImage(
                                          fit: BoxFit.contain,
                                          image: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/social-app-c11f0.appspot.com/o/defaults%2FAdd%20Photo.jpg?alt=media&token=4a7df8fb-d2d1-471e-825e-676da258ad16',
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            if (AppCubit.get(context).postImage != null)
                              IconButton(
                                onPressed: () {
                                  AppCubit.get(context).removePostImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    Icons.close,
                                    size: 20.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            '# tags',
                            style: TextStyle(
                              color: secondColor,
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
