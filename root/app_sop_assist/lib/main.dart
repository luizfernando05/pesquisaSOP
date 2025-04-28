import 'package:app_sop_assist/ui/home/home_screen.dart';
import 'package:app_sop_assist/ui/singin/singin_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SopAssist',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/singin': (context) => const SinginScreen(),
      },
    );
  }
}
