class UserModel {
  UserModel({this.name, this.mail, this.phone, this.uId, this.bio, this.image, this.cover});

  String? name;
  String? mail;
  String? phone;
  String? uId;
  String? bio;
  String? cover;
  String? image;

  UserModel.fromJson(Map<String, dynamic> json) {
    mail = json['mail'];
    name = json['name'];
    phone = json['phone'];
    image = json['image'];
    cover = json['cover'];
    bio = json['bio'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mail': mail,
      'phone': phone,
      'uId': uId,
      'bio': bio,
      'cover':cover,
      'image': image,
    };
  }
}
