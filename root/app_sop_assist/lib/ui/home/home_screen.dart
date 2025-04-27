import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAB4ABA),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
           Image.asset('assets/ilustration/Logo.png'),
          Image.asset('assets/ilustration/Mulher.png'),

          /*Container(
            child: Text("data"),
            width: 500,
            height: 300,
            color: Colors.white,
          ),*/
          Column(
            children: [
              Image.asset(
                'assets/ilustration/Ellipse.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ],
          ),

          /*Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(child: Text("Login", style: TextStyle(fontSize: 20))),
              Center(child: Text("Senha", style: TextStyle(fontSize: 20))),
            ],*/

          //),
        ],
      ),
    );
  }
}
