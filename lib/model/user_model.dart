import 'dart:ffi';

class UserModel {
  String userId;
  String userName;
  String userEmail;
  String userPassword;
  int userPoints;
  int userAnsweredQuestions;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPassword,
    required this.userPoints,
    required this.userAnsweredQuestions,
  });

}
