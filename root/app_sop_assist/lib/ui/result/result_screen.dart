import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:translator/translator.dart';

class ResultScreen extends StatefulWidget {
  final String predictionResult;
  final String? llmAdviceText;

  const ResultScreen({
    super.key,
    required this.predictionResult,
    required this.llmAdviceText,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<void>? _launched; // ignore: unused_field
  final translator = GoogleTranslator(); 
  
  late Future<String> _translatedAdviceFuture;

  Future<String> _translateAdvice(String textToTranslate) async {
    if (textToTranslate.isEmpty) return '';
    try {
      final translation = await translator.translate(textToTranslate, from: 'en', to: 'pt');
      return translation.text;
    } catch (e) {
      print('Erro ao traduzir conselho da LLM: $e');
      return 'Não foi possível traduzir o conselho.';
    }
  }

  @override
  void initState() {
    super.initState();
    // Iniciar a tradução assim que o widget é inicializado
    _translatedAdviceFuture = _translateAdvice(widget.llmAdviceText ?? '');
  }

  Future<void> launchInBrowserView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
      throw Exception('Não foi possível abrir $url');
    }
  }

  // Método para formatar a frase principal ("seja portadora" ou "não seja portadora")
  String _getPredictionPhrase(String result) {
    if (result.toLowerCase() == 'positive') {
      return 'seja portadora';
    } else if (result.toLowerCase() == 'negative') {
      return 'não seja portadora';
    }
    return result; 
  }

  // Método para formatar a classificação no container de resultado ("Positiva" ou "Negativa")
  String _formatClassification(String result) {
    if (result.toLowerCase() == 'positive') {
      return 'Positiva';
    } else if (result.toLowerCase() == 'negative') {
      return 'Negativa';
    }
    return result; 
  }

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

    // Chamar os métodos de formatação
    final String predictionPhrase = _getPredictionPhrase(
      widget.predictionResult,
    );
    final String formattedClassificationText = _formatClassification(
      widget.predictionResult,
    );

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
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        color: const Color(0xFF202020),
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Com base nos seus dados, é provável que você ',
                        ),
                        TextSpan(
                          text: predictionPhrase,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFAB4ABA),
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
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF646464),
                              ),
                              children: [
                                const TextSpan(text: 'Classificação: '),
                                TextSpan(
                                  text: formattedClassificationText,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    height: 2,
                                    fontWeight: FontWeight.normal,
                                    color: const Color(0xFF202020),
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
                      const SizedBox(width: 5.0),
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
                          setState(() {
                            _launched = launchInBrowserView(
                              toLaunchLeiaSobreSop,
                            );
                          });
                        },
                        splashColor: const Color(0xFFAB4ABA).withOpacity(0.2),
                        highlightColor: const Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.heart,
                              color: Color(0xFFAB4ABA),
                            ),
                            const SizedBox(width: 12),
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
                        splashColor: const Color(0xFFAB4ABA).withOpacity(0.2),
                        highlightColor: const Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.firstAidKit,
                              color: Color(0xFFAB4ABA),
                            ),
                            const SizedBox(width: 12),
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
                        splashColor: const Color(0xFFAB4ABA).withOpacity(0.2),
                        highlightColor: const Color(
                          0xFFAB4ABA,
                        ).withOpacity(0.1),
                        child: Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.instagramLogo,
                              color: Color(0xFFAB4ABA),
                            ),
                            const SizedBox(width: 12),
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

                   FutureBuilder<String>(
                    future: _translatedAdviceFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFFAB4ABA)),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Conselho da inteligência artificial:",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                color: const Color(0xFFAB4ABA),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Erro ao carregar conselho: ${snapshot.error}',
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.red,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        );
                      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Informações da nossa assistente:",
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                color: const Color(0xFFAB4ABA),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: screenHeight * 0.2,
                                minHeight: screenHeight * 0.05, 
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE0E0E0)), 
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView( 
                                child: Text(
                                  snapshot.data!, 
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: const Color(0xFF202020),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
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