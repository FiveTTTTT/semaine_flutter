import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rendu_chat_app/services/auth_service.dart';
import 'package:rendu_chat_app/user_infos.dart';
import 'package:rendu_chat_app/services/user_service.dart';

import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) => AuthService()),
      Provider<UserService>( // Créez une instance de UserService ici
        create: (context) => UserService(), // Vous pouvez ajuster la façon dont UserService est créé ici
      ),
    ],
    child: const LoginApp(),
  ));
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login App",
      theme: ThemeData(
          canvasColor: Colors.white,
          primarySwatch: Colors.deepPurple,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue, foregroundColor: Colors.white)),
      home: FutureBuilder<bool>(
          future: context.read<AuthService>().isLoggedIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!) {
                print("co");
                return UserInfos(username: "username", userId: "userId",userService: context.read<UserService>(),);
              } else {
                print("pas co");
                return LoginPage();
              }
            }
            return const CircularProgressIndicator();
          }),
      routes: {'/user': (context) => UserInfos(username: '', userId: '',userService: context.read<UserService>(),)},
    );
  }
}
