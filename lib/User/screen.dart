import 'package:flutter/material.dart';
import 'package:flutter_chat_demo/CustomWidgets/custom_text_field.dart';
import 'package:flutter_chat_demo/Registration/model.dart';
import 'package:flutter_chat_demo/Util/dialog.dart';
import 'package:flutter_chat_demo/const.dart';
import 'package:flutter_chat_demo/global.dart';
import 'package:flutter_chat_demo/main.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
    TextEditingController mobileNumberController = new TextEditingController();
  FocusNode focusNode = new FocusNode();
  bool hasErrorInUserInfo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Friend"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        child: Icon(Icons.done),
        onPressed: () {
          doRegister();
        },
      ),
      body: Column(
        children: <Widget>[
          CustomTextField(
            icon: Icons.person,
            controller: mobileNumberController,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            hintText: 'mobile number',
            labelText: "Mobile Number",
            maxLength: 14,
            //validator: () {},
            hasError: hasErrorInUserInfo,
          ),
        ],
      ),
    );
  }

  void doRegister() async {
    final String title = 'Add Friend';
    String message;
    TitleFetchResponse result;

    setState(() {
      hasErrorInUserInfo = false;
    });

    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              content: ListTile(
                leading: CircularProgressIndicator(),
                title: new Text('Please Wait ...'),
              ),
            ),
      );

      try {
        print('hit1');
        final RegistrationApi api =
            new RegistrationApi(httpDataSource, authenticator.sessionToken);

        result = await api.doRegister(mobileNumberController.text);
      } catch (exception) {
        await showAlertDialog(context, title, '${exception.message}');
      } finally {
        setState(() {
          hasErrorInUserInfo = false;
        });
      }

      Navigator.of(context).pop();

      message = result.title=='nill'? "User not found" :result.title+ " added succcessfully.";
      await showAlertDialog(context, title, message);
      if (!message.contains('not found')) {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) => new MainScreen(
                  currentUserId: UserIds.currentUser,
                  newUser: "Y",
                ),
          ),
        );
      }
    } catch (exception) {
      await showAlertDialog(context, title, exception.message);
    }
  }
}
