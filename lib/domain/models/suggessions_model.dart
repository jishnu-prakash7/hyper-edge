class SuggessionModel {
  List<UserDetailsModel> data;
  int total;

  SuggessionModel({
    required this.data,
    required this.total,
  });

  factory SuggessionModel.fromJson(Map<String, dynamic> json) =>
      SuggessionModel(
        data: List<UserDetailsModel>.from(
            json["data"].map((x) => UserDetailsModel.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}

class UserDetailsModel {
  String backGroundImage;
  String id;
  String userName;
  String email;
  String password;
  String profilePic;
  String phone;
  bool online;
  bool blocked;
  bool verified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String role;
  bool isPrivate;
  String? bio;
  String? name;

  UserDetailsModel({
    required this.backGroundImage,
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.phone,
    required this.online,
    required this.blocked,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.role,
    required this.isPrivate,
    this.bio,
    this.name,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserDetailsModel(
        backGroundImage: json["backGroundImage"],
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        profilePic: json["profilePic"],
        phone: json["phone"],
        online: json["online"],
        blocked: json["blocked"],
        verified: json["verified"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        role: json["role"],
        isPrivate: json["isPrivate"],
        bio: json["bio"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "backGroundImage": backGroundImage,
        "_id": id,
        "userName": userName,
        "email": email,
        "password": password,
        "profilePic": profilePic,
        "phone": phone,
        "online": online,
        "blocked": blocked,
        "verified": verified,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "role": role,
        "isPrivate": isPrivate,
        "bio": bio,
        "name": name,
      };
}
