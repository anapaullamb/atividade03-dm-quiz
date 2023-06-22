import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class MessagesApp {
  static const errorPasswordMistach = 'Senha e Confirmação não conferem!';
  static const errorUserExist = 'Usuário Já Castrado!';
  static const errorUserNoExist = 'Usuário Não Castrado!';
  static const errorUserNoUpdate = 'Usuário Não Atualizado!';
  static const errorDefault = 'Operação Não Permitida!';
  static const successUserInsert = 'Usuário Cadastrado!';
  static const successUserUpdate = 'Usuário Atualizado!';
  static const successUserDelete = 'Usuário Apagado!';
  static showCustom(
    BuildContext context,
    String message, {
    Color color = Colors.red,
    IconData icon = Icons.error,
  }) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
      toastDuration: const Duration(seconds: 3),
    );
  }
}
