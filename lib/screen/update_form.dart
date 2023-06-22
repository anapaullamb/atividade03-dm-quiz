import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../common/routes/view_routes.dart';
import '../components/user_login_header.dart';
import '../model/user_model.dart';

import '../common/messages/messages.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';

class UpdateUser extends StatefulWidget {
  //UserModel user;
  // UpdateUser(this.user, {super.key});
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  final _userLoginController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userEmailController = TextEditingController();
  final _userPasswordController = TextEditingController();
  final _userPasswordConfirmController = TextEditingController();
  late final UserModel user;

  @override
  void didChangeDependencies() {
    user = ModalRoute.of(context)!.settings.arguments as UserModel;
    _getUserData(user);
    super.didChangeDependencies();
  }

  _getUserData(UserModel user) async {
    setState(() {
      _userLoginController.text = user.userId;
      _userNameController.text = user.userName;
      _userEmailController.text = user.userEmail;
      _userPasswordController.text = user.userPassword;
      // _userPasswordConfirmController.text = user;
    });
  }

  _updateUserData(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_userPasswordController.text.trim() !=
          _userPasswordConfirmController.text.trim()) {
        MessagesApp.showCustom(context, MessagesApp.errorPasswordMistach);
        return 0;
      }

      UserModel userUpdated = UserModel(
        userId: _userLoginController.text.trim(),
        userName: _userNameController.text.trim(),
        userEmail: _userEmailController.text.trim(),
        userPassword: _userPasswordController.text.trim(),
        userPoints: 0,
        userAnsweredQuestions: 0,
      );

      final db = SqlLiteDb();
      db.updateUser(userUpdated).then(
        (value) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: MessagesApp.successUserUpdate,
            btnOkOnPress: () => Navigator.pop(context),
            btnOkText: 'OK',
          ).show();
        },
      ).catchError((error) {
        AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          title: MessagesApp.errorUserNoUpdate,
          btnCancelOnPress: () => Navigator.pop(context),
          btnCancelText: 'OK',
        ).show();
      });
    }
  }

  void _restartPoints(BuildContext context) {
      user.userPoints = 0;
      user.userAnsweredQuestions =0;
      final db = SqlLiteDb();
      db.updateUser(user).then(
            (value) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: MessagesApp.successUserUpdate,
            btnOkOnPress: () => {},
            btnOkText: 'OK',
          ).show();
        },
      ).catchError((error) {
        AwesomeDialog(
          context: context,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          title: MessagesApp.errorUserNoUpdate,
          btnCancelOnPress: () => {},
          btnCancelText: 'OK',
        ).show();
      });
    }

  _deleteUserData(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      // animType: AnimType.topSlide,
      title: 'Confirma Exclusão???',
      btnCancelOnPress: () => Navigator.pop(context),
      btnOkText: 'Sim',
      btnOkOnPress: () {
        final db = SqlLiteDb();
        db.deleteUser(_userLoginController.text.trim()).then(
          (value) {
            AwesomeDialog(
              context: context,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              title: MessagesApp.successUserDelete,
              btnOkOnPress: () => Navigator.pushNamedAndRemoveUntil(
                  context, RoutesApp.home, (Route<dynamic> route) => false),
              btnOkText: 'OK',
            ).show();
          },
        ).catchError((error) {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            title: MessagesApp.errorDefault,
            btnCancelOnPress: () => Navigator.pop(context),
            btnCancelText: 'OK',
          ).show();
        });
      },
      btnCancelText: 'Cancelar',
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualização de Usuário'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text( "Meu Perfil",  style: TextStyle(fontSize: 18)),
                Text("Meus pontos: ${user.userPoints}",  style: const TextStyle(fontSize: 15)),
                Text("Meus jogos: ${user.userAnsweredQuestions}",  style: const TextStyle(fontSize: 15)),
                UserTextField(
                  hintName: 'login',
                  icon: Icons.person,
                  controller: _userLoginController,
                  enableField: false,
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
                    left: 40,
                    right: 40,
                  ),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _updateUserData(context),
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Atualizar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _deleteUserData(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                              shape: const StadiumBorder()),
                          child: const Text(
                            'Deletar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _restartPoints(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: const StadiumBorder()),
                  child: const Text(
                    'Reiniciar pontuação',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
