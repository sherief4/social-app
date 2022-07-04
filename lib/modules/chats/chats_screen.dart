import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats_details/chats_details_screen.dart';
import 'package:social_app/shared/constants.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is GetCommentModelsErrorState) {
          showToast(state.error, ToastState.error);
        }
      },
      builder: (context, state) {
        if (state is GetCommentModelsLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          );
        } else {
          if (AppCubit.get(context).allUsers.isNotEmpty) {
            return ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return buildChatItem(
                  context: context,
                  model: AppCubit.get(context).allUsers[index],
                );
              },
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                ),
                child: Container(
                  color: Colors.grey,
                  height: 1.0,
                ),
              ),
              itemCount: AppCubit.get(context).allUsers.length,
            );
          } else {
            return const Center(
              child: Text('There is no users to chat with!!'),
            );
          }
        }
      },
    );
  }

  Widget buildChatItem({
    required UserModel model,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        navigateTo(
          context,
          ChatsDetailsScreen(
            userModel: model,
          ),
        );
      },
      child: SizedBox(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
                radius: 25.0,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  '${model.name}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
