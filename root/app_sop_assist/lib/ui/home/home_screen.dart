import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAB4ABA),
      body: Stack(
        // uma coisa em cima da outra
        children: [
          Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/ilustration/Mulher.png',
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .5,
                ),
              ),
            ],
          ),

          // Container branco (ao invés da imagem de elipse)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child: Container(
              height: MediaQuery.of(context).size.height * .6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.elliptical(
                    3000,
                    2000,
                  ), // Aqui é o ajuste da curvatura
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .07),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/flor.png',
                        width: 19,
                        height: 21,
                      ),
                      SizedBox(width: 7),
                      const Text(
                        'SOP Assist',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * .1),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * .63,
                    height: MediaQuery.of(context).size.height * .06,
                    child: ElevatedButton(
                      onPressed: () {
                        //rota para a tela de criar conta
                        Navigator.pushNamed(context, '/singin');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB4ABA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Criar conta',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.width * .03),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * .63,
                    height: MediaQuery.of(context).size.height * .06,
                    child: OutlinedButton(
                      onPressed:
                          () => {
                            //rota para a tela de login
                            Navigator.pushNamed(
                              context,
                              '/login',
                            ), //tela ainda a ser feita
                          },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Fazer login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF202020),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Image.asset(
                    'assets/logo/logo.png',
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
