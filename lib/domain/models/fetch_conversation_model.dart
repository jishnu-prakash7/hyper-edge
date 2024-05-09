// class ConversationModel {
//   final String id;
//   final List<String> members;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   // final String? lastMessage;
//   // final DateTime? lastMessageTime;

//   ConversationModel({
//     required this.id,
//     required this.members,
//     required this.createdAt,
//     required this.updatedAt,
//     //  this.lastMessage,
//     //  this.lastMessageTime,
//   });

//   factory ConversationModel.fromJson(Map<String, dynamic> json) {
//     return ConversationModel(
//       id: json['_id'],
//       members: List<String>.from(json['members']),
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       // lastMessage: json["lastMessage"],
//       // lastMessageTime: DateTime.parse(json["lastMessageTime"]),
//     );
//   }
// }

// class ConversationResponse {
//   final List<ConversationModel> data;
//   final int status;
//   final String message;

//   ConversationResponse({
//     required this.data,
//     required this.status,
//     required this.message,
//   });

//   factory ConversationResponse.fromJson(Map<String, dynamic> json) {
//     return ConversationResponse(
//       data: (json['data'] as List)
//           .map((item) => ConversationModel.fromJson(item))
//           .toList(),
//       status: json['status'],
//       message: json['message'],
//     );
//   }
// }

class ConversationModel {
  String id;
  List<String> members;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? lastMessage;
  DateTime? lastMessageTime;

  ConversationModel({
    required this.id,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.lastMessage,
    this.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["_id"],
        members: List<String>.from(json["members"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        lastMessage: json["lastMessage"],
        lastMessageTime: json["lastMessageTime"] == null
            ? null
            : DateTime.parse(json["lastMessageTime"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "members": List<dynamic>.from(members.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime?.toIso8601String(),
      };
}
