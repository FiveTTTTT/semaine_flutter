import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rendu_chat_app/models/user_model.dart';
import 'package:rendu_chat_app/services/user_service.dart';
import 'package:rendu_chat_app/widgets/login_text_feild.dart';

class UserInfos extends StatefulWidget {
  final String username;
  final String userId;
  final UserService userService;
  const UserInfos(
      {Key? key,
      required this.username,
      required this.userId,
      required this.userService})
      : super(key: key);

  @override
  State<UserInfos> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfos> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  void updateUserName(context) {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      print(userNameController.text);
      var theUser =
      User(userId: widget.userId, username: userNameController.text);
      widget.userService.updateUser(theUser);
      print('username updated!');
    } else {
      print('username not updated!');
    }
    widget.userService.readAllUsers().then((List<User> userList) {
      // userList contient la liste d'utilisateurs
      print("Liste d'utilisateurs :");
      for (var user in userList) {
        print("UserID: ${user.userId}, Username: ${user.username}");
      }
    }).catchError((error) {
      // En cas d'erreur lors de la récupération des utilisateurs
      print("Une erreur s'est produite lors de la récupération des utilisateurs : $error");
    });

  }

  @override
  Widget build(BuildContext context) {
    String username = widget.username;
    String userId = widget.userId;

    return Scaffold(
      body: Column(children: [
        Text(
          "Bonjour $username",
          style: TextStyle(color: Colors.indigo),
        ),
        Form(
          key: _formkey,
          child: TextFormField(
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 5) {
                return "Your username should be more than 5 characters";
              } else if (value != null && value.isEmpty) {
                return "Please type your username";
              }
              return null;
            },
            controller: userNameController,
            decoration: const InputDecoration(
                counterStyle: TextStyle(color: Colors.green),
                hintText: 'Add your username',
                iconColor: Colors.green,
                labelStyle: TextStyle(color: Colors.green),
                hintStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder()),
          ),
        ),
        Text(userId),
        ElevatedButton(
            onPressed: () {
              print("testetset");
              updateUserName(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
            )),
      ]),
    );
  }
}
