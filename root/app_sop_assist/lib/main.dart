import 'package:app_sop_assist/ui/home/home_screen.dart';
import 'package:app_sop_assist/ui/login/login_screen.dart';
import 'package:app_sop_assist/ui/prediction/prediction_screen.dart';
import 'package:app_sop_assist/ui/singin/singin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color(0xFFAB4ABA)),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SopAssist',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/singin': (context) => const SinginScreen(),
        '/prediction': (context) => const PredictionScreen(),
      },
    );
  }
}
