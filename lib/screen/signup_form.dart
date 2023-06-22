import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import '../common/messages/messages.dart';
import '../common/routes/view_routes.dart';
import '../components/user_login_header.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';
import '../model/user_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _userLoginController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userPasswordConfirmController = TextEditingController();

  @override
  void dispose() {
    _userLoginController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    _userPasswordController.dispose();
    _userPasswordConfirmController.dispose();
    super.dispose();
  }

  void signUp(BuildContext context) async {
    // Retorna TRUE em caso de
    // conteudo valido de todos os campos
    if (_formKey.currentState!.validate()) {
      if (_userPasswordController.text.trim() !=
          _userPasswordConfirmController.text.trim()) {
        MessagesApp.showCustom(context, MessagesApp.errorPasswordMistach);
        return;
      }
      UserModel user = UserModel(
        userId: _userLoginController.text.trim(),
        userName: _userNameController.text.trim(),
        userEmail: _userEmailController.text.trim(),
        userPassword: _userPasswordController.text.trim(),
        userPoints: 0,
        userAnsweredQuestions: 0,
      );

      final db = SqlLiteDb();
      db.saveUser(user).then(
        (value) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: MessagesApp.successUserInsert,
            btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                context, RoutesApp.home, (Route<dynamic> route) => false),
            btnOkText: 'OK',
          ).show(); // Message
        },
      ).catchError((error) {
        if (error.toString().contains('UNIQUE constraint failed')) {
          MessagesApp.showCustom(
            context,
            MessagesApp.errorUserExist,
          );
        } else {
          MessagesApp.showCustom(
            context,
            error.toString(),
          );
        }
      });
      // await db.saveUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Login'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const UserLoginHeader('Cadastrar Login'),
                UserTextField(
                  hintName: 'login',
                  icon: Icons.person,
                  controller: _userLoginController,
                ),
                UserTextField(
                  hintName: 'Nome',
                  icon: Icons.person_2_outlined,
                  controller: _userNameController,
                ),
                UserTextField(
                  hintName: 'Email',
                  icon: Icons.email,
                  controller: _userEmailController,
                  inputType: TextInputType.emailAddress,
                ),
                UserTextField(
                  isObscured: true,
                  hintName: 'Senha',
                  icon: Icons.lock,
                  controller: _userPasswordController,
                ),
                UserTextField(
                  isObscured: true,
                  hintName: 'Confirmação de Senha',
                  controller: _userPasswordConfirmController,
                  icon: Icons.lock,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 80,
                    right: 80,
                  ),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => signUp(context),
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Não possui uma Conta???'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context,
                              RoutesApp.home, (Route<dynamic> route) => false);
                        },
                        child: const Text('Cadastra-se'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
