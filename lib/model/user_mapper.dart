import 'package:login_with_sqllite/external/database/user_table_schema.dart';
import 'package:login_with_sqllite/model/user_model.dart';

abstract class UserMapper {
  // Mapeia um Usuario para o formato a ser salvo
  // no banco de dados
  static Map<String, dynamic> toMapBD(UserModel user) {
    return {
      UserTableSchema.userIDColumn: user.userId,
      UserTableSchema.userNameColumn: user.userName,
      UserTableSchema.userEmailColumn: user.userEmail,
      UserTableSchema.userPasswordColumn: user.userPassword,
      UserTableSchema.userPointsColumn: user.userPoints,
      UserTableSchema.userAnsweredQuestionsColumn: user.userAnsweredQuestions,
    };
  }

  // Mapeia um Map vindo do SqlLite para um
  // uma classer UserModel
  static UserModel fromMapBD(Map<String, dynamic> map) {
    return UserModel(
      userId: map[UserTableSchema.userIDColumn],
      userName: map[UserTableSchema.userNameColumn],
      userEmail: map[UserTableSchema.userEmailColumn],
      userPassword: map[UserTableSchema.userPasswordColumn],
      userPoints: map[UserTableSchema.userPointsColumn],
      userAnsweredQuestions: map[UserTableSchema.userAnsweredQuestionsColumn],
    );
  }

  // clona um UserModel
  static UserModel cloneUser(UserModel user) {
    return UserModel(
      userId: user.userId,
      userName: user.userName,
      userEmail: user.userEmail,
      userPassword: user.userPassword,
      userPoints: user.userPoints,
      userAnsweredQuestions: user.userAnsweredQuestions,
    );
  }
}
