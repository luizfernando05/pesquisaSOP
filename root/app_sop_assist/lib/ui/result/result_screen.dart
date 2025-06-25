import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // Declarando _launched como uma variável de estado para que possa ser atualizada
  // ignore: unused_field
  Future<void>? _launched;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final Uri toLaunchInstagram = Uri(
      scheme: 'https',
      host: 'www.instagram.com',
      path: '/mulheres.na.ciencia/',
    );
    final Uri toLaunchLeiaSobreSop = Uri(
      scheme: 'https',
      host: 'www.msdmanuals.com',
      path:
          '/pt/casa/problemas-de-sa%C3%BAde-feminina/dist%C3%BArbios-menstruais-e-sangramento-vaginal-an%C3%B4malo/s%C3%ADndrome-do-ov%C3%A1rio-polic%C3%ADstico-sop',
    );
    final Uri toLaunchTratamentos = Uri(
      scheme: 'https',
      host: 'www.tuasaude.com',
      path: '/tratamento-para-ovario-policistico/',
    );

    // Função para lançar a URL no navegador in-app
    Future<void> launchInBrowserView(Uri url) async {
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
        throw Exception('Não foi possível abrir $url');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            PhosphorIconsRegular.caretLeft,
            size: 24,
            color: Color(0xFF202020),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Predição',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: const Color(0xFF202020),
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  // Texto principal com "portadora" colorido
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        color: const Color(0xFF202020),
                        fontWeight: FontWeight.w500,
                        height:
                            1.2, // Ajuste a altura da linha para melhor leitura
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Com base nos seus dados, é provável que você ',
                        ),
                        TextSpan(
                          text: 'seja portadora',
                          style: GoogleFonts.poppins(
                            color: const Color(
                              0xFFAB4ABA,
                            ), // Cor roxa para "portadora"
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(
                          text: ' da síndrome dos ovários policísticos.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  // Container de Resultado
                  Center(
                    child: Container(
                      width:
                          MediaQuery.of(
                            context,
                          ).size.width, // Ocupa a largura total disponível
                      padding: const EdgeInsets.all(
                        16.0,
                      ), // Padding interno de 16px em todos os lados
                      decoration: BoxDecoration(
                        color: Colors.white, // Fundo branco
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ), 
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                        ), 
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start, 
                        children: [
                          Text(
                            "Resultado",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF202020),
                            ),
                          ),
                          const SizedBox(height: 8),

                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.roboto(
                                // Usando Roboto para as classificações, como na imagem
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: const Color(
                                  0xFF646464,
                                ), // Cor cinza para o texto
                              ),

                              children: [
                                TextSpan(text: 'Classificação: '),
                                TextSpan(
                                  text: 'Positiva', //Ajustar para receber do back
                                  style: GoogleFonts.roboto(
                                    // Usando Roboto para as classificações, como na imagem
                                    fontSize: 14,
                                    height: 2,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(
                                      0xFF202020,
                                    ), 
                                  ),
                                ),
                              ],
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: const Color(
                                  0xFF646464,
                                ), 
                              ),

                              children: [
                                TextSpan(text: 'Confiança da predição: '),
                                TextSpan(
                                  text: '86%', //Ajustar para receber do back
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(
                                      0xFF202020,
                                    ), // Cor cinza para o texto
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        PhosphorIconsRegular.info,
                        size: 17,
                        color: Color(0xFF646464),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ), 
                      Expanded(
                        child: Text(
                          "Ressaltamos que esta predição é realizada por um modelo computacional, sujeito a falhas. A confirmação médica é essencial.",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            height: 1.1,
                            color: const Color(0xFF646464),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04), 

                  Text(
                    "Entre em contato com um médico para confirmar o diagnóstico.",
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      height: 1.2,
                      color: const Color(0xFF202020),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Ao tocar, chamamos o método para abrir a URL
                          setState(() {
                            _launched = launchInBrowserView(
                              toLaunchLeiaSobreSop,
                            );
                          });
                        },
                        splashColor: Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.2), // Cor do efeito de toque
                        highlightColor: Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.1), // Cor quando pressionado
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIconsRegular.heart,
                              color: Color(0xFFAB4ABA),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Leia sobre a SOP",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.2,
                                color: const Color(0xFF202020),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _launched = launchInBrowserView(
                              toLaunchTratamentos,
                            );
                          });
                        },
                        splashColor: Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.2), 
                        highlightColor: Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.1), 
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIconsRegular.firstAidKit,
                              color: Color(0xFFAB4ABA),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Tratamentos para a SOP",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.2,
                                color: const Color(0xFF202020),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _launched = launchInBrowserView(toLaunchInstagram);
                          });
                        },
                        splashColor: Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.2), 
                        highlightColor: Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.1), 
                        child: Row(
                          children: [
                            Icon(
                              PhosphorIconsRegular.instagramLogo,
                              color: Color(0xFFAB4ABA),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Conheça-nos",
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.2,
                                color: const Color(0xFF202020),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: SvgPicture.asset(
                      'assets/ilustration/ultima.svg',
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
