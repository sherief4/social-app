import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/comment_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import '../../modules/chats/chats_screen.dart';
import '../../modules/feeds/feeds_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../modules/users/users_screen.dart';

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

  List<PostModel> allPosts = [];
  List<String> postId = [];
  List<int> likes = [];
  List<int> commentsNumber = [];

  void getPosts() {
    emit(AppGetPostsLoadingState());
    _fireStore.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postId.add(element.id);
          allPosts.add(PostModel.fromJson(element.data()));
          emit(AppGetPostsSuccessState());
        }).catchError((error) {
          emit(AppGetPostsErrorState(error: error.toString()));
        });
      }
      for (var element in value.docs) {
        element.reference.collection('comments').get().then((value) {
          commentsNumber.add(value.docs.length);
          emit(AppGetPostsSuccessState());
        });
      }
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
      comments.clear();
      getPostComments(postId, index);
      emit(AddCommentSuccessState());
    }).catchError((error) {
      emit(AddCommentErrorState(error: error.toString()));
    });
  }

  List<CommentModel> comments = [];
  List<String> commentsProfilePics = [];

  void getPostComments(String postId, int index) {
    emit(GetCommentsLoadingState());
    _fireStore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        comments.add(CommentModel.fromJson(element.data()));
        emit(GetCommentsSuccessState(postId: postId, index: index));
      }
    }).catchError((error) {
      emit(GetCommentsErrorState(error: error.toString()));
    });
  }

  void getCommentsProfilePics({required String postId , required int index}) {
    for (var element in comments) {
      commentsProfilePics.add(getProfilePic(element.profileId));
    }
    emit(GetCommentProfilePicSuccessState(index: index ,postId: postId ));
  }

  String getProfilePic(String? uId) {
    String picUrl = '';
    _fireStore.collection('users').doc(uId).get().then((value) {
      picUrl = value.data()!['image'];
    });
    print(picUrl);
    return picUrl;
  }
}
