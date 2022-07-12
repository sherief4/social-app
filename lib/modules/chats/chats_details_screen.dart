import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/icon_broken.dart';

class ChatsDetailsScreen extends StatelessWidget {
  const ChatsDetailsScreen({Key? key, required this.userModel})
      : super(key: key);
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      AppCubit.get(context).getMessages(receiverId: userModel.uId!);

      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final TextEditingController controller = TextEditingController();
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0.0,
              iconTheme: const IconThemeData(color: Colors.black),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '${userModel.image}',
                    ),
                    radius: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      '${userModel.name}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Column(
                children: [
                  if(AppCubit.get(context).messages.isNotEmpty) ListView.separated(
                    shrinkWrap: true,
                    physics:const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      MessageModel message = AppCubit.get(context).messages[index];

                   if(AppCubit.get(context).userModel!.uId == message.senderId){
                     return buildMyMessage(message);
                   }
                   return buildMessage(message);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: double.infinity,
                        height: 8.0,
                      );
                    },
                    itemCount: AppCubit.get(context).messages.length,
                  ),

                ],
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 10.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        border: Border.all(
                          color: mainColor,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type your message here',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    height: 50.0,
                    width: 50.0,
                    child: MaterialButton(
                      minWidth: 1.0,
                      onPressed: () {
                        AppCubit.get(context).sendMessage(
                          message: controller.text,
                          senderId: FirebaseAuth.instance.currentUser!.uid,
                          receiverId: userModel.uId,
                        );
                      },
                      child: const Icon(
                        IconBroken.Send,
                        size: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  Widget buildMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadiusDirectional.only(
            bottomEnd: Radius.circular(
              10.0,
            ),
            topStart: Radius.circular(
              10.0,
            ),
            topEnd: Radius.circular(
              10.0,
            ),
          ),
        ),
        child: Text(
         '${message.message}',
        ),
      ),
    );
  }

  Widget buildMyMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: const BorderRadiusDirectional.only(
            bottomStart: Radius.circular(
              10.0,
            ),
            topStart: Radius.circular(
              10.0,
            ),
            topEnd: Radius.circular(
              10.0,
            ),
          ),
        ),
        child: Text(
          '${message.message}',
        ),
      ),
    );
  }
}
