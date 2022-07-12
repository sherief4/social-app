import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  FeedsScreen({Key? key}) : super(key: key);
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddCommentSuccessState) {
          commentController.clear();
        }
        if (state is AddCommentErrorState) {
          showToast(state.error, ToastState.error);
        }
        if (state is GetPostCommentsDataSuccessState) {
          showAddCommentSheet(
              context: context,
              index: state.index,
              postId: AppCubit.get(context).postId[state.index]);
        }
      },
      builder: (context, state) {
        if (state is AppGetPostsLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          );
        } else {
          if(AppCubit.get(context).postCommentsNumber.isNotEmpty){
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (state is GetCommentModelsLoadingState)
                  LinearProgressIndicator(
                    color: secondColor,
                  ),
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: const [
                      Image(
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          'https://img.freepik.com/free-photo/friendly-smiling-young-woman-with-brown-hair-gives-good-advice-suggestion-what-buy-indicates-with-fore-finger-upper-right-corner_273609-18601.jpg?w=740',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Communicate with friends",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                  while(AppCubit.get(context).postCommentsNumber.length > index){
                    return  buildPostItem(context,
                        AppCubit.get(context).postModels[index], index, state);
                  }
                  return  CircularProgressIndicator(color: mainColor,);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 10.0,
                    );
                  },
                  itemCount: AppCubit.get(context).postModels.length,
                ),
              ],
            );
          }else{
            return const Center(child: Text('No posts to show!'),);
          }
        }
      },
    );
  }

  Widget buildPostItem(
          BuildContext context, PostModel model, int index, AppStates state) =>
      Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${model.userProfileImage}',
                    ),
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
                              '${model.userName}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                          ],
                        ),
                        Text(
                          '${model.dateTime}',
                          style: const TextStyle(
                            height: 1.5,
                            color: Colors.blueGrey,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 16.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                '${model.postText}',
                style: const TextStyle(
                  color: Colors.black,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: [
                      SizedBox(
                        height: 25.0,
                        child: MaterialButton(
                          minWidth: 1.0,
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: const Text(
                            "#Software_development",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (model.postImage!.isNotEmpty)
                Container(
                  height: 140.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('${model.postImage}'),
                    ),
                  ),
                ),
              Row(
                children: [
                  MaterialButton(
                    minWidth: 1.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${AppCubit.get(context).postLikes[index]}',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  MaterialButton(
                    minWidth: 1.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Chat,
                          color: Colors.yellow,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${AppCubit.get(context).postCommentsNumber[index]}',
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${AppCubit.get(context).userModel!.image}',
                    ),
                    radius: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  MaterialButton(
                    minWidth: 1.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AppCubit.get(context).getPostCommentsData(
                          postId: AppCubit.get(context).postId[index],
                          index: index);
                    },
                    child: const Text(
                      'Write a Comment',
                      style: TextStyle(color: Colors.blueGrey),
                    ),
                  ),
                  const Spacer(),
                  MaterialButton(
                    minWidth: 1.0,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      AppCubit.get(context).likePost(
                          postId: AppCubit.get(context).postId[index]);
                    },
                    child: Row(
                      children: const [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          'Like',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  void showAddCommentSheet({
    required BuildContext context,
    required int index,
    required String postId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 25,
          width: double.infinity,
          decoration: const BoxDecoration(),
          child: Padding(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '${AppCubit.get(context).postLikes[index]}',
                            style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          const Icon(
                            IconBroken.Arrow___Right_2,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        AppCubit.get(context).likePost(
                            postId: AppCubit.get(context).postId[index]);
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.0,
                        child: Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return buildCommentCard(
                        context: context,
                        comment:
                            '${AppCubit.get(context).commentModels[index].comment}',
                        profilePic:
                            AppCubit.get(context).commentsProfilePics[index],
                      );
                    },
                    itemCount: AppCubit.get(context).commentModels.length,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          '${AppCubit.get(context).userModel!.image}',
                        ),
                        radius: 20.0,
                      ),
                      Container(
                        height: 44,
                        width: 284,
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              20.0,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 280.0,
                            height: 40.0,
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              left: 8.0,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20.0,
                                ),
                              ),
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: commentController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4.0,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).addComment(
                              postId: postId,
                              comment: commentController.text,
                              profileId: FirebaseAuth.instance.currentUser!.uid,
                              index: index,
                            );
                          },
                          icon: Icon(
                            IconBroken.Send,
                            color: secondColor,
                          ),
                        ),
                        radius: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      AppCubit.get(context).commentsProfilePics.clear();
      AppCubit.get(context).commentModels.clear();
      commentController.clear();
    });
  }

  Widget buildCommentCard(
      {required BuildContext context,
      required String comment,
      required String profilePic}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              profilePic,
            ),
            radius: 20.0,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 40.0,
              ),
              padding: const EdgeInsets.only(
                right: 8.0,
                left: 8.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: mainColor, width: 2.0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              child: Text(
                comment,
                style: TextStyle(
                  color: mainColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
