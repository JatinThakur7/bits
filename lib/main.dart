import 'package:bits/Screens/Welcome/welcome_screen.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './constants.dart';
import '../Screens/Login/login_screen.dart';
import 'utils/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String _userId = await AppPreferences.getString(userId);
  runApp(MyApp(_userId?.isEmpty ?? true));
}

class MyApp extends StatelessWidget {
  final bool isEmpty;

  const MyApp(
    this.isEmpty, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seven Bits',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: DoubleBack(
        child: isEmpty ? LoginScreen() : WelcomeScreen(),
      ),
    );
  }
}
