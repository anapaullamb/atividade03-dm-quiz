import 'package:login_with_sqllite/model/user_mapper.dart';
import 'package:login_with_sqllite/model/user_model.dart';

void main() {
  var user = UserModel(
    userId: 'teste',
    userName: 'teste',
    userEmail: 'teste',
    userPassword: 'teste',
    userPoints: 0,
    userAnsweredQuestions: 0,
  );

  print(user);

  var u = UserMapper.toMapBD(user);
  print(u);
  print(u.runtimeType);

  var t = UserMapper.fromMapBD(u);
  print(t);
  print(t.runtimeType);

  var x = UserMapper.cloneUser(t);
  print(x);
  print(x.runtimeType);
}
