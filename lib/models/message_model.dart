class MessageModel {
  MessageModel({
    this.message,
    this.dateTime,
    this.senderId,
    this.receiverId,
  });

  String? message;
  String? senderId;
  String? receiverId;
  String? dateTime;

  MessageModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    dateTime = json['dateTime'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'dateTime': dateTime,
      'senderId': senderId,
      'receiverId': receiverId,
    };
  }
}
