import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_with_sqllite/model/question_model.dart';
import '../common/routes/view_routes.dart';
import '../components/user_login_header.dart';
import '../model/user_model.dart';

import '../common/messages/messages.dart';
import '../components/user_text_field.dart';
import '../external/database/db_sql_lite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late QuestionModel question;
   List<String> answers = [];
  late final UserModel user;

  @override
  void didChangeDependencies() {
    user = ModalRoute.of(context)!.settings.arguments as UserModel;
    super.didChangeDependencies();
  }
  bool _updateUserPontos(bool isCorrect) {
    if(isCorrect){
      user.userPoints++;
    }
    user.userAnsweredQuestions++;
    final db = SqlLiteDb();
    db.updateUser(user).then((value) { return true; },
    ).catchError((error) {
      return false;
    });
    return false;
  }
  void _mostraDialog(bool isCorrect) {
    final result = isCorrect ? 'Correta' : 'Errada';
    final dialogType = isCorrect ? DialogType.success : DialogType.error;

    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      headerAnimationLoop: false,
      title: 'Resultado',
      desc: 'Sua resposta está $result!',
      btnOkOnPress: () {
        setState(() {});
      },
    ).show();
  }
  void _verificaResposta(option){
    final isCorrect = option == question.correctAnswer;
    bool updateSuccess = false;
      updateSuccess=_updateUserPontos(isCorrect);
    _mostraDialog(isCorrect);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: FutureBuilder<QuestionModel>(
          future: getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.connectionState == ConnectionState.done) {
                 question = snapshot.data!;
                return SingleChildScrollView  (
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text( question.category),
                            ),
                            Expanded(
                              child: Text( question.difficulty, textAlign: TextAlign.end),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Text("${user.userAnsweredQuestions + 1}"),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Text( question.text,  style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ...question.answers.map<Widget>((option) => ElevatedButton(
                            onPressed: () {_verificaResposta(option);},
                            child: Text(option),
                          )),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text( "Pontos: ${user.userPoints}",  style: TextStyle(fontSize: 12)),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RoutesApp.loginUpdate,
                                  arguments: user,
                                );
                              },
                              child: const Text('Ver meus dados'),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return waitingIndicator();
              }
            } else {
              return waitingIndicator();
            }
          },
        ));
  }

  Center waitingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

Future<QuestionModel> getData() async {
  const requestApi = "https://the-trivia-api.com/v2/questions?limit=1";
  var response = await http.get(Uri.parse(requestApi));
  var json = jsonDecode(response.body);
  QuestionModel question = QuestionModel.fromJson(json[0]);
  question.answers.add(question.correctAnswer);
  question.answers.shuffle();
  return QuestionModel.fromJson(json[0]);
}