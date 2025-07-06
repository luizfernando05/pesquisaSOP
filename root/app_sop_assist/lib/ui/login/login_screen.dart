// ignore_for_file: use_build_context_synchronously

import 'package:app_sop_assist/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_sop_assist/ui/prediction/prediction_screen.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  var showPassword = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final storage = FlutterSecureStorage();

  // Variável para controlar se uma requisição já está em andamento
  bool _isLoginInProgress = false;

  Future<void> _login(BuildContext context) async {
    // Evita múltiplas chamadas se já estiver em progresso
    if (_isLoginInProgress) {
      return;
    }

    setState(() {
      _isLoginInProgress = true; // Inicia o progresso
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // Oculta qualquer SnackBar existente antes de mostrar um novo
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
          backgroundColor: Color(0xFFAB4ABA),
        ),
      );
      setState(() {
        _isLoginInProgress =
            false; // Permite novas tentativas após o erro de validação local
      });
      return;
    }

    final url = Uri.parse('http://10.0.2.2:3000/user/login');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException(
                'A requisição excedeu o tempo limite de 5 segundos.',
              );
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token']; // Pega o token
        print('TOKEN: $token');

        if (token != null) {
          await storage.write(key: 'jwt_token', value: token);
          // Salva o token
        } else {
          // Lidar com erros
          ScaffoldMessenger.of(
            context,
          ).hideCurrentSnackBar(); // Oculta SnackBar anterior
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Ops não consegui encontrar seu o token',
              ),
              backgroundColor: Color(0xFFAB4ABA),
            ),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login realizado com sucesso!'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFFAB4ABA),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    const PredictionScreen(), // Token já ficou salvo
          ),
        );
      } else {
        // Isso aqui oculta qualquer SnackBar existente antes de mostrar um novo
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final error = jsonDecode(response.body);
        String message = 'Erro desconhecido';

        if (error is Map) {
          if (error.containsKey('errors') && error['errors'] is Map) {
            final errors = error['errors'] as Map;
            message = errors.values.join('\n');
          } else if (error.containsKey('messages')) {
            message = error['messages'];
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFFAB4ABA),
          ),
        );
      }
    } on TimeoutException catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'A conexão demorou demais. Verifique sua conexão ou contate o suporte. Detalhe: $e',
          ),
          backgroundColor: const Color(0xFFAB4ABA),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro na conexão. Por favor, tente novamente.'),
          backgroundColor: const Color(0xFFAB4ABA),
        ),
      );
    } finally {
      setState(() {
        _isLoginInProgress =
            false; // Finaliza o progresso, permitindo novas tentativas
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAB4ABA),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * .15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              decoration: const BoxDecoration(
                color: Color(0xFFFCFCFC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bem vinda de volta!',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: const Color(0xFFAB4ABA),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Faça login para continuar',
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF646464),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                      'assets/ilustration/menina.png',
                      height: 160,
                      width: 160,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF646464),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFAB4ABA),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF646464),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFAB4ABA),
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                showPassword
                                    ? PhosphorIconsRegular.eye
                                    : PhosphorIconsRegular.eyeClosed,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    SizedBox(height: MediaQuery.of(context).size.height * .03),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        // Desabilita o botão enquanto o login estiver em progresso
                        onPressed:
                            _isLoginInProgress ? null : () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAB4ABA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            _isLoginInProgress
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                ) // Mostra um spinner enquanto carrega
                                : Text(
                                  'Entrar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    color: const Color(0xFFFEFCFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Não tem uma conta?',
                          style: GoogleFonts.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFF202020),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/singin');
                          },
                          child: Text(
                            ' Crie agora',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFAB4ABA),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        PhosphorIconsRegular.caretLeft,
                        size: 24,
                        color: Color(0xFFFEFCFF),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                    ),
                    Text(
                      'Voltar',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: const Color(0xFFFEFCFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
