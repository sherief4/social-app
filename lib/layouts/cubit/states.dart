abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserSuccessState extends AppStates {}

class AppGetUserLoadingState extends AppStates {}

class AppGetUserErrorState extends AppStates {
  AppGetUserErrorState({required this.error});

  final String error;
}

class AddNewPostState extends AppStates {}

class ChangeBottomNavigationState extends AppStates {}

class PickProfileImageSuccessState extends AppStates {}

class PickProfileImageErrorState extends AppStates {
  PickProfileImageErrorState({required this.error});

  final String error;
}

class PickPostImageSuccessState extends AppStates {}

class PickPostImageErrorState extends AppStates {
  PickPostImageErrorState({required this.error});

  final String error;
}

class UploadProfileImageSuccessState extends AppStates {}

class UploadProfileImageErrorState extends AppStates {
  UploadProfileImageErrorState({required this.error});

  final String error;
}

class PickCoverImageSuccessState extends AppStates {}

class PickCoverImageErrorState extends AppStates {
  PickCoverImageErrorState({required this.error});

  final String error;
}

class UploadCoverImageSuccessState extends AppStates {}

class UploadImageLoadingState extends AppStates {}

class UploadCoverImageErrorState extends AppStates {
  UploadCoverImageErrorState({required this.error});

  final String error;
}

class UserUpdateLoadingState extends AppStates {}

class UserUpdateSuccessState extends AppStates {}

class UserUpdateErrorState extends AppStates {
  UserUpdateErrorState({required this.error});

  final String error;
}

class CreatePostWithImageSuccessState extends AppStates {}

class CreatePostWithImageErrorState extends AppStates {
  CreatePostWithImageErrorState({required this.error});

  final String error;
}

class CreatePostLoadingState extends AppStates {}

class CreatePostSuccessState extends AppStates {}

class CreatePostErrorState extends AppStates {
  CreatePostErrorState({required this.error});

  final String error;
}

class RemovePostImageState extends AppStates {}

class RemoveProfileImageState extends AppStates {}

class RemoveCoverImageState extends AppStates {}

class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsErrorState extends AppStates {
  final String error;

  AppGetPostsErrorState({required this.error});
}

class LikePostLoadingState extends AppStates {}

class LikePostSuccessState extends AppStates {}

class LikePostErrorState extends AppStates {
  LikePostErrorState({required this.error});

  final String error;
}

class AddCommentSuccessState extends AppStates {}

class AddCommentErrorState extends AppStates {
  final String error;

  AddCommentErrorState({required this.error});
}





class GetCommentModelsLoadingState extends AppStates{}

class GetCommentModelsSuccessState extends AppStates{
  GetCommentModelsSuccessState({required this.postId , required this.index});
  final String postId;
  final int index;
}

class GetCommentModelsErrorState extends AppStates{
  GetCommentModelsErrorState({required this.error});
  final String error;
}
class GetCommentProfilePicsLoadingState extends AppStates{}

class GetCommentProfilePicsSuccessState extends AppStates{
  GetCommentProfilePicsSuccessState({required this.index , required this.postId});
  final String postId;
  final int index;
}
class GetPicLoadingState extends AppStates{}
class GetPicSuccessState extends AppStates{}
class GetPicErrorState extends AppStates{
  GetPicErrorState({required this.error});
  final String error;
}

class GetPostCommentsDataLoadingState extends AppStates{}
class GetPostCommentsDataSuccessState extends AppStates{
  GetPostCommentsDataSuccessState({required this.index});
  final int index;
}
class GetPostCommentsDataErrorState extends AppStates{
  GetPostCommentsDataErrorState({required this.error});
  final String error;
}
