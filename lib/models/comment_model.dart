class CommentModel {
  CommentModel({
    this.comment,
    this.profileId,
  });

  String? comment;
  String? profileId;

  CommentModel.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    profileId = json['profileId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'comment': comment,
      'profileId': profileId,
    };
  }
}
