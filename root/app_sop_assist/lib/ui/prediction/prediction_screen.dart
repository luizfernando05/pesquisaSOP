import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _menstrualCycleController = TextEditingController();
  final TextEditingController _amgValueController = TextEditingController();
  final TextEditingController _leftFolliclesController = TextEditingController();
  final TextEditingController _rightFolliclesController = TextEditingController();

  String? _gainedWeightValue;
  String? _hairLossValue;
  String? _darkeningSkinValue;
  String? _hasAcneValue;
  String? _consumesFastFoodValue;

  bool _isLoading = false;
  String _predictionResult = '';
  final _storage = const FlutterSecureStorage();

  @override
  void dispose() {
    _weightController.dispose();
    _menstrualCycleController.dispose();
    _amgValueController.dispose();
    _leftFolliclesController.dispose();
    _rightFolliclesController.dispose();
    super.dispose();
  }

  Widget _buildDropdownField({
    required String labelText,
    required List<String> items,
    String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF646464),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: selectedValue,
          isDense: true,
          icon: const SizedBox(),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFAB4ABA), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
            suffixIcon: const Icon(
              PhosphorIconsRegular.caretDown,
              color: Color(0xFF646464),
            ),
          ),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: GoogleFonts.roboto(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF646464),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFAB4ABA), width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 2,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _makePrediction() async {
    print('>>> Início de _makePrediction');

    setState(() {
      _isLoading = true;
      _predictionResult = 'Carregando dados do usuário...';
    });

    final patientId = await _storage.read(key: 'patient_id');
    final token = await _storage.read(key: 'jwt_token');

    if (patientId == null || token == null) {
      setState(() {
        _isLoading = false;
        _predictionResult = 'Erro: ID do paciente ou token de autenticação não encontrado. Faça login novamente.';
      });
      print('<<< Fim de _makePrediction: patientId ou token ausente.');
      return;
    }

    setState(() {
      _predictionResult = 'Enviando dados de predição...';
    });

    // Validação e tratamento de dados de entrada ---

    // Tratamento para substituir vírgula por ponto em campos decimais
    String weightText = _weightController.text.replaceAll(',', '.');
    String amgValueText = _amgValueController.text.replaceAll(',', '.');

    final double? weight = double.tryParse(weightText);
    final int? cycle = int.tryParse(_menstrualCycleController.text);
    final double? amg = double.tryParse(amgValueText);
    final int? leftFollicles = int.tryParse(_leftFolliclesController.text);
    final int? rightFollicles = int.tryParse(_rightFolliclesController.text);

    // Validação básica
    if (weight == null || cycle == null || amg == null ||
        leftFollicles == null || rightFollicles == null ||
        _gainedWeightValue == null || _hairLossValue == null ||
        _darkeningSkinValue == null || _hasAcneValue == null ||
        _consumesFastFoodValue == null) {
      setState(() {
        _isLoading = false;
        _predictionResult = 'Por favor, preencha todos os campos corretamente com valores válidos.';
      });
      print('<<< Fim de _makePrediction: Campos incompletos/inválidos.');
      return;
    }

    // Converter 'Sim'/'Não' para boolean
    final bool weightGain = _gainedWeightValue == 'Sim';
    final bool hairLoss = _hairLossValue == 'Sim';
    final bool darkeningSkin = _darkeningSkinValue == 'Sim';
    final bool pimple = _hasAcneValue == 'Sim';
    final bool fastFood = _consumesFastFoodValue == 'Sim';

    // Construir o corpo da requisição JSON
    final Map<String, dynamic> requestBody = {
      "patientId": patientId,
      "weight": weight,
      "cycle": cycle,
      "amg": amg,
      "weightGain": weightGain,
      "hairLoss": hairLoss,
      "darkeningSkin": darkeningSkin,
      "pimple": pimple,
      "fastFood": fastFood,
      "leftFollicles": leftFollicles,
      "rightFollicles": rightFollicles,
    };

    // Imprime o JSON no console antes de enviar, apagar depois
    print('--- JSON a ser enviado ---');
    print(json.encode(requestBody));
    print('--------------------------');

    // URL do endpoint de predição
    final Uri url = Uri.parse('http://10.0.2.2:3000/medical');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        setState(() {
          _predictionResult = 'Predição realizada com sucesso!';
        });
        print('Requisição bem-sucedida! Resposta: ${response.body}');
      } else {
        setState(() {
          _predictionResult = 'Erro ao realizar predição: ${response.statusCode} - ${response.body}';
        });
        print('Erro na requisição: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _predictionResult = 'Erro de conexão ao enviar predição: $e';
      });
      print('Erro de conexão ao enviar predição: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    print('<<< Fim de _makePrediction.');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double fieldHorizontalSpacing = screenWidth * 0.03;
    final double fieldVerticalSpacing = screenHeight * 0.02;

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
                  Text(
                    'Insira os dados do seu exame para realizar a predição',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.05,
                      color: const Color(0xFF202020),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: screenHeight * 0.04),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _weightController,
                          labelText: 'Qual o seu peso? (kg)',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: fieldHorizontalSpacing),
                      Expanded(
                        child: _buildTextField(
                          controller: _menstrualCycleController,
                          labelText: 'Ciclo menstrual?',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fieldVerticalSpacing),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _amgValueController,
                          labelText: 'Valor do AMG?',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: fieldHorizontalSpacing),
                      Expanded(
                        child: _buildDropdownField(
                          labelText: 'Você ganhou peso?',
                          items: const ['Sim', 'Não'],
                          selectedValue: _gainedWeightValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              _gainedWeightValue = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fieldVerticalSpacing),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          labelText: 'Queda de cabelo?',
                          items: const ['Sim', 'Não'],
                          selectedValue: _hairLossValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              _hairLossValue = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: fieldHorizontalSpacing),
                      Expanded(
                        child: _buildDropdownField(
                          labelText: 'Pele escurecendo?',
                          items: const ['Sim', 'Não'],
                          selectedValue: _darkeningSkinValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              _darkeningSkinValue = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fieldVerticalSpacing),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          labelText: 'Apresenta acne?',
                          items: const ['Sim', 'Não'],
                          selectedValue: _hasAcneValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              _hasAcneValue = newValue;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: fieldHorizontalSpacing),
                      Expanded(
                        child: _buildDropdownField(
                          labelText: 'Consome fast-food?',
                          items: const ['Sim', 'Não'],
                          selectedValue: _consumesFastFoodValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              _consumesFastFoodValue = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: fieldVerticalSpacing),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _leftFolliclesController,
                          labelText: 'Número de folículos no ovário esquerdo',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: fieldHorizontalSpacing),
                      Expanded(
                        child: _buildTextField(
                          controller: _rightFolliclesController,
                          labelText: 'Número de folículos no ovário direito',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: screenWidth * 0.12,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _makePrediction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAB4ABA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Fazer Predição',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.045,
                                color: const Color(0xFFFEFCFF),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),

                  if (_predictionResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _predictionResult,
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: _predictionResult.contains('sucesso')
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const SizedBox(height: 16),

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
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}