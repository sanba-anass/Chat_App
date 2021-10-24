import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat_app/providers/auth_provider.dart';
import 'package:fun_chat_app/providers/data_provider.dart';
import 'package:fun_chat_app/services/firebase_auth.dart';
import 'package:fun_chat_app/services/firebase_fire.dart';
import 'package:fun_chat_app/views/signup.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseAuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseFireService(),
        ),
        ChangeNotifierProvider(
          create: (_) => DataProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
      ),
      title: 'Material App',
      home: SignUp(),
    );
  }
}
