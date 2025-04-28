import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAB4ABA),
      body: Stack(// uma coisa em cima da outra
        children: [
          Column(
            children: [
              const SizedBox(height: 40), 
              Image.asset(
                'assets/logo/logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/ilustration/Mulher.png',
                  width: 215,
                  height: 275,
                  fit: BoxFit.contain,
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
              height: 395,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.elliptical(3000, 2000), // Aqui é o ajuste da curvatura
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 70),
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
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 246,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () { //rota para a tela de criar conta
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
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 246,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => {//rota para a tela de login
                        Navigator.pushNamed(context, '/login') //tela ainda a ser feita
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
