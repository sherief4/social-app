import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/network/cache_helper.dart';
import 'package:social_app/shared/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  int curIn = 0;

  List<String> titles = ['Home', 'Chats', 'Add Post', 'Users', 'Settings'];

  List<Widget> screens = [
    FeedsScreen(),
    const ChatsScreen(),
    const NewPostScreen(),
    const UsersScreen(),
    const SettingsScreen()
  ];

  void changeBottomNavigation(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(AddNewPostState());
    } else {
      curIn = index;
      emit(ChangeBottomNavigationState());
    }
  }

  //Get User Profile Data

  UserModel? userModel;

  Future<void> getUserData() async {
    emit(AppGetUserLoadingState());

    await _fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserSuccessState());
    }).catchError((error) {
      emit(AppGetUserErrorState(error: error.toString()));
    });
  }

  //Image Methods

  File? profileImage;
  File? coverImage;
  File? postImage;
  String? profileImageUrl;
  String? postImageUrl;
  String? coverImageUrl;

  var picker = ImagePicker();

  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PickPostImageSuccessState());
    } else {
      emit(PickPostImageErrorState(error: "No Image Selected"));
    }
  }

  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(PickProfileImageSuccessState());
      uploadProfileImage();
    } else {
      emit(PickProfileImageErrorState(error: "No Image Selected"));
    }
  }

  Future<void> pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(PickCoverImageSuccessState());
      uploadCoverImage();
    } else {
      emit(PickCoverImageErrorState(error: "No Image Selected"));
    }
  }

  void uploadProfileImage() {
    emit(UploadImageLoadingState());
    _storage
        .ref()
        .child(
            'users/profiles/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        emit(UploadProfileImageErrorState(error: error));
      });
    }).catchError((error) {
      emit(UploadProfileImageErrorState(error: error));
    });
  }

  void uploadCoverImage() {
    emit(UploadImageLoadingState());
    _storage
        .ref()
        .child('users/covers/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        emit(UploadCoverImageSuccessState());
      }).catchError((error) {
        emit(UploadCoverImageErrorState(error: error));
      });
    }).catchError((error) {
      emit(UploadCoverImageErrorState(error: error));
    });
  }

  UserModel? updatedUserModel;

  //Update User Profile

  void updateUser({
    required String name,
    required String phone,
    required String bio,
  }) async {
    updatedUserModel = UserModel(
      name: name,
      mail: userModel!.mail,
      image: profileImageUrl ?? userModel!.image,
      phone: phone,
      bio: bio,
      uId: FirebaseAuth.instance.currentUser!.uid,
      cover: coverImageUrl ?? userModel!.cover,
    );

    emit(UserUpdateLoadingState());

    await _fireStore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(updatedUserModel!.toMap())
        .then((value) {
      emit(UserUpdateSuccessState());
      getUserData();
    }).catchError((error) {
      emit(UserUpdateErrorState(error: error));
    });
  }

  void removeProfileImage() {
    profileImage = null;
    profileImageUrl = '';
    emit(RemoveProfileImageState());
  }

  void removeCoverImage() {
    coverImage = null;
    coverImageUrl = '';
    emit(RemoveCoverImageState());
  }

  //Create Post Section

  void createPostWithImage(
      {required String dateTime, required String postText}) {
    emit(UploadImageLoadingState());
    _storage
        .ref()
        .child('users/posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          dateTime: dateTime,
          text: postText,
          postImageUrl: value,
        );
        emit(CreatePostWithImageSuccessState());
      }).catchError((error) {
        emit(CreatePostWithImageErrorState(error: error));
      });
    }).catchError((error) {
      emit(CreatePostWithImageErrorState(error: error));
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImageUrl,
  }) {
    emit(CreatePostLoadingState());
    PostModel postModel = PostModel(
      userModel!.name,
      text,
      dateTime,
      postImageUrl ?? '',
      FirebaseAuth.instance.currentUser!.uid,
      userModel!.image,
    );
    _fireStore.collection('posts').add(postModel.toMap()).then((value) {
      emit(CreatePostSuccessState());

      getPosts();
    }).catchError((error) {
      emit(CreatePostErrorState(error: error.toString()));
    });
  }

  void removePostImage() {
    postImage = null;
    postImageUrl = "";
    emit(RemovePostImageState());
  }

  //Get Posts
  //Like Post
  //Add Comment

  List<String> postId = [];
  List<PostModel> postModels = [];
  List<int> postLikes = [];
  List<int> postCommentsNumber = [];

  Future<void> getPostModels() async {
    emit(GetPostModelsLoadingState());
    await _fireStore.collection('posts').get().then((value) {
      for (var element in value.docs) {
        postModels.add(PostModel.fromJson(element.data()));
        postId.add(element.id);
      }
      emit(GetPostModelsSuccessState());
    }).catchError((error) {
      emit(GetPostModelsErrorState(error: error.toString()));
    });
  }

  Future<void> getLikes() async {
    emit(GetPostLikesLoadingState());
    await _fireStore.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          postLikes.add(value.docs.length);
        });
      }
      emit(GetPostModelsSuccessState());
    }).catchError((error) {
      emit(GetPostLikesErrorState(error: error.toString()));
    });
  }

  Future<void> getCommentsNumbers() async {
    emit(GetPostCommentsNumbersLoadingState());
    await _fireStore.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          postCommentsNumber.add(value.docs.length);
        });
      }
      emit(GetPostCommentsNumbersSuccessState());
    }).catchError((error) {
      emit(GetPostCommentsNumbersErrorState(error: error.toString()));
    });
  }

  Future<void> getPosts() async {
    emit(AppGetPostsLoadingState());
    await getPostModels().then((value) {
      getLikes().then((value) {
        getCommentsNumbers();

      });
    }).then((value) {
      emit(AppGetPostsSuccessState());
    }).catchError((error) {
      emit(AppGetPostsErrorState(error: error.toString()));
    });
  }

  void likePost({required String postId}) {
    emit(LikePostLoadingState());
    _fireStore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'like': true,
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState(error: error.toString()));
    });
  }

  void addComment({
    required String postId,
    required String comment,
    required String profileId,
    required int index,
  }) {
    emit(LikePostLoadingState());
    CommentModel _commentModel = CommentModel(
      comment: comment,
      profileId: profileId,
    );
    _fireStore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set(_commentModel.toMap())
        .then((value) {
      //TODO: After adding a new comment refresh comments to get all comments
      // commentModels.clear();
      // commentsProfilePics.clear();
      emit(AddCommentSuccessState());
    }).catchError((error) {
      emit(AddCommentErrorState(error: error.toString()));
    });
  }

  List<CommentModel> commentModels = [];
  List<String> commentsProfilePics = [];

  Future<void> getPostCommentModels(String postId, int index) async {
    emit(GetCommentModelsLoadingState());
    await _fireStore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        commentModels.add(CommentModel.fromJson(element.data()));
        emit(GetCommentModelsSuccessState(postId: postId, index: index));
      }
    }).catchError((error) {
      emit(GetCommentModelsErrorState(error: error.toString()));
    });
  }

  Future<void> getCommentsProfilePics(
      {required String postId, required int index}) async {
    emit(GetCommentProfilePicsLoadingState());
    for (var element in commentModels) {
      await getProfilePic(element.profileId).then((value) {
        commentsProfilePics.add(value);
        emit(GetCommentProfilePicsSuccessState(index: index, postId: postId));
      });
    }
  }

  Future<String> getProfilePic(String? uId) async {
    emit(GetPicLoadingState());
    String picUrl = '';
    await _fireStore.collection('users').doc(uId).get().then((value) {
      picUrl = value.data()!['image'];
      emit(GetPicSuccessState());
    }).catchError((error) {
      emit(GetPicErrorState(error: error.toString()));
    });

    return picUrl;
  }

  Future<void> getPostCommentsData(
      {required String postId, required int index}) async {
    emit(GetPostCommentsDataLoadingState());
    getPostCommentModels(postId, index).then((value) {
      getCommentsProfilePics(postId: postId, index: index).then((value) {
        emit(GetPostCommentsDataSuccessState(index: index));
      }).catchError((error) {
        emit(GetPostCommentsDataErrorState(error: error.toString()));
      });
    });
  }

//Chats

//Get All Users
  List<UserModel> allUsers = [];

  void getAllUsers() async {
    emit(GetAllUsersLoadingState());
    if (allUsers.isEmpty) {
      allUsers.clear();
      await _fireStore.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uId'] != FirebaseAuth.instance.currentUser!.uid) {
            allUsers.add(UserModel.fromJson(element.data()));
          }
        }
        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState(error: error.toString()));
      });
    }
  }

//Send Message
  void sendMessage({
    required String message,
    required String senderId,
    required String? receiverId,
  }) {
    MessageModel messageModel = MessageModel(
      message: message,
      senderId: senderId,
      receiverId: receiverId,
      dateTime: DateTime.now().toString(),
    );

    //set my chats
    _fireStore
        .collection('users')
        .doc(senderId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessagesErrorState(error: error.toString()));
    });

    //then set receiver chats

    _fireStore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(senderId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessagesErrorState(error: error.toString()));
    });
  }

//Get messages
  List<MessageModel> messages = [];

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
        print(element.data());
      }
      emit(GetChatMessagesSuccessState());
    });
  }

  //Sign Out

  Future<void> signOut() async {
    emit(SignOutLoadingState());
    await FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData('uId').then((value) {
        uId = null;
        curIn = 0;
        emit(SignOutSuccessState());
      });
    });
  }
}
