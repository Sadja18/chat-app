class User {
  String? userName;
  int? loginStatus;
  int? userId;
  String? email;
  String? authToken;

  User({
    this.userId,
    this.userName,
    this.loginStatus,
    this.authToken,
    this.email,
  });

  User.fromMap(Map<String, dynamic> info)
      : userId = info['userId'],
        userName = info['userName'],
        loginStatus = info['loginStatus'],
        authToken = info['authToken'],
        email = info['email'];

  Map<String, Object?> toMap() {
    return {
      "userId": userId,
      "userName": userName,
      "loginStatus": loginStatus,
      "authToken": authToken,
      "email": email,
    };
  }
}
