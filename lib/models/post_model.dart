class PostModel {
  PostModel(
    this.userName,
    this.postText,
    this.dateTime,
    this.postImage,
    this.uId,
    this.userProfileImage,
  );

  String? userName;
  String? postText;
  String? dateTime;
  String? postImage;
  String? uId;
  String? userProfileImage;

  PostModel.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    postText = json['postText'];
    dateTime = json['dateTime'];
    postImage = json['postImage'];
    uId = json['uId'];
    userProfileImage = json['userProfileImage'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'postText': postText,
      'dateTime': dateTime,
      'postImage': postImage,
      'uId': uId,
      'userProfileImage': userProfileImage,
    };
  }
}
