class UserModel {
  String email;
  String userName;
  String phone;
  String password;
  UserModel({
    required this.email,
    required this.userName,
    required this.phone,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      userName: json['userName'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'userName': userName,
      'phone': phone,
      'password': password,
    };
  }
}
