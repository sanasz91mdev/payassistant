import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/CustomWidgets/custom_text_field.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
TextEditingController mobileNumberController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(controller: ,)

        ],
      ),
    );
  }
}
