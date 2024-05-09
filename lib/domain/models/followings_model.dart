
class FollowingsModel {
    List<Following> following;
    int totalCount;

    FollowingsModel({
        required this.following,
        required this.totalCount,
    });

    factory FollowingsModel.fromJson(Map<String, dynamic> json) => FollowingsModel (
        following: List<Following>.from(json["following"].map((x) => Following.fromJson(x))),
        totalCount: json["totalCount"],
    );

    Map<String, dynamic> toJson() => {
        "following": List<dynamic>.from(following.map((x) => x.toJson())),
        "totalCount": totalCount,
    };
}

class Following {
    String id;
    String userName;
    String email;
    String password;
    String phone;
    bool online;
    bool blocked;
    bool verified;
    String role;
    bool isPrivate;
    DateTime createdAt;
    DateTime updatedAt;
    int v;
    String? bio;
    String? name;
    String profilePic;
    String backGroundImage;

    Following({
        required this.id,
        required this.userName,
        required this.email,
        required this.password,
        required this.phone,
        required this.online,
        required this.blocked,
        required this.verified,
        required this.role,
        required this.isPrivate,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
         this.bio,
         this.name,
        required this.profilePic,
        required this.backGroundImage,
    });

    factory Following.fromJson(Map<String, dynamic> json) => Following(
        id: json["_id"],
        userName: json["userName"],
        email: json["email"],
        password: json["password"],
        phone: json["phone"],
        online: json["online"],
        blocked: json["blocked"],
        verified: json["verified"],
        role: json["role"],
        isPrivate: json["isPrivate"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        bio: json["bio"],
        name: json["name"],
        profilePic: json["profilePic"],
        backGroundImage: json["backGroundImage"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "email": email,
        "password": password,
        "phone": phone,
        "online": online,
        "blocked": blocked,
        "verified": verified,
        "role": role,
        "isPrivate": isPrivate,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "bio": bio,
        "name": name,
        "profilePic": profilePic,
        "backGroundImage": backGroundImage,
    };
}
