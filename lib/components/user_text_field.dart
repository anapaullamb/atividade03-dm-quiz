import 'package:flutter/material.dart';

class UserTextField extends StatelessWidget {
  String hintName;
  IconData icon;
  TextEditingController controller;
  TextInputType inputType;
  bool isObscured;
  bool enableField;

  UserTextField({
    super.key,
    required this.hintName,
    required this.icon,
    required this.controller,
    this.isObscured = false,
    this.inputType = TextInputType.text,
    this.enableField = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: isObscured,
        enabled: enableField,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          // errorBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          // ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintName,
          labelText: hintName,
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor Digite $hintName';
          }
          if ((hintName == 'Email') && !validateEmail(value)) {
            return 'Digite um email válido';
          }
          return null;
        },
      ),
    );
  }
}

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}
