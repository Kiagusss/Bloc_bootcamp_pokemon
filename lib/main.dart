import 'package:coba_api_flutter/coba_api.dart';
import 'package:coba_api_flutter/tugas_tampilan.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalculatorApp(),
    );
  }
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  AllPokemonApi(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '0';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _input = '0';
      } else if (buttonText == '=') {
        _input = _evaluateExpression(_input);
      } else if (buttonText == '=') {
        _input = _evaluateExpression(_input);
      } else if (buttonText == '⌫') {
        _input =
            _input.length > 1 ? _input.substring(0, _input.length - 1) : '0';
      } else if (buttonText == '×' &&
          _input.isNotEmpty &&
          _input.endsWith('×')) {
        // Pemeriksaan khusus untuk operator '×'
        {
          // Jika operator sebelumnya adalah '×', hanya izinkan input angka
          if (_isNumeric(buttonText)) {
            _input += buttonText;
          }
        }
      } else if // Pemeriksaan khusus untuk mengganti 0 dengan angka baru
          (_input == '0' && _isNumeric(buttonText)) {
        {
          _input = buttonText;
        }
      } else {
        _input += buttonText;
      }
    });
  }

  String _evaluateExpression(String expression) {
    try {
      // Evaluasi ekspresi matematika menggunakan operator matematika bawaan Dart
      double result = _parseExpression(expression);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  double _parseExpression(String expression) {
    // Parsing dan evaluasi ekspresi matematika secara manual
    List<String> tokens = _tokenizeExpression(expression);
    return _evaluateTokens(tokens);
  }

  List<String> _tokenizeExpression(String expression) {
    // Membuat daftar token dari ekspresi matematika
    List<String> tokens = [];
    String currentToken = '';

    for (int i = 0; i < expression.length; i++) {
      if (_isOperator(expression[i])) {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
          currentToken = '';
        }
        tokens.add(expression[i]);
      } else {
        currentToken += expression[i];
      }
    }

    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    return tokens;
  }

  double _evaluateTokens(List<String> tokens) {
    // Evaluasi ekspresi matematika berdasarkan token
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);

      switch (operator) {
        case '+':
          result += operand;
          break;
        case '-':
          result -= operand;
          break;
        case '×':
          result *= operand;
          break;
        case '÷':
          result /= operand;
          break;
        case '%':
          result %= operand;
          break;
        case '^':
          result = _power(result, operand);
          break;
        default:
          throw FormatException('Invalid operator: $operator');
      }
    }

    return result;
  }

  double _power(double base, double exponent) {
    // Menghitung pangkat
    return exponent == 0 ? 1 : base * _power(base, exponent - 1);
  }

  bool _isOperator(String value) {
    // Memeriksa apakah karakter adalah operator
    return value == '+' ||
        value == '-' ||
        value == '×' ||
        value == '÷' ||
        value == '%' ||
        value == '^';
  }

  bool _isNumeric(String str) {
    try {
      double.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                _input,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Table(
            children: [
              TableRow(
                children: [
                  _buildButton('C'),
                  _buildButton('%'),
                  _buildButton('⌫'),
                  _buildButton('÷'),
                ],
              ),
              TableRow(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('×'),
                ],
              ),
              TableRow(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('-'),
                ],
              ),
              TableRow(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('+'),
                ],
              ),
              TableRow(
                children: [
                  _buildButton('%'),
                  _buildButton('^'),
                  _buildButton('.'),
                  _buildButton('='),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
