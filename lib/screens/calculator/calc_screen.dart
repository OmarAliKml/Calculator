import 'package:flutter/material.dart';

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Professional Calculator',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _output = "0";
  String _currentNumber = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;
  bool _shouldClearCurrent = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (_currentNumber.isNotEmpty) {
          _num1 = double.parse(_currentNumber);
          _operation = buttonText;
          _currentNumber = "";
        }
      } else if (buttonText == "=") {
        if (_currentNumber.isNotEmpty && _operation.isNotEmpty) {
          _num2 = double.parse(_currentNumber);
          switch (_operation) {
            case "+":
              _currentNumber = (_num1 + _num2).toString();
              break;
            case "-":
              _currentNumber = (_num1 - _num2).toString();
              break;
            case "×":
              _currentNumber = (_num1 * _num2).toString();
              break;
            case "÷":
              _currentNumber = (_num1 / _num2).toString();
              break;
          }
          _operation = "";
          _num1 = double.parse(_currentNumber);
          _shouldClearCurrent = true;
        }
      } else if (buttonText == "±") {
        if (_currentNumber.isNotEmpty) {
          if (_currentNumber.startsWith("-")) {
            _currentNumber = _currentNumber.substring(1);
          } else {
            _currentNumber = "-" + _currentNumber;
          }
        }
      } else if (buttonText == "%") {
        if (_currentNumber.isNotEmpty) {
          double number = double.parse(_currentNumber);
          _currentNumber = (number / 100).toString();
        }
      } else if (buttonText == ".") {
        if (!_currentNumber.contains(".")) {
          _currentNumber = _currentNumber + buttonText;
        }
      } else {
        if (_shouldClearCurrent) {
          _currentNumber = buttonText;
          _shouldClearCurrent = false;
        } else {
          _currentNumber = _currentNumber + buttonText;
        }
      }

      if (_currentNumber.isEmpty) {
        _output = "0";
      } else {
        _output = _currentNumber;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Color(0xFF333333),
            padding: EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _buildButton("C", color: Colors.grey),
                          _buildButton("±", color: Colors.grey),
                          _buildButton("%", color: Colors.grey),
                          _buildButton("÷", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _buildButton("7"),
                          _buildButton("8"),
                          _buildButton("9"),
                          _buildButton("×", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _buildButton("4"),
                          _buildButton("5"),
                          _buildButton("6"),
                          _buildButton("-", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _buildButton("1"),
                          _buildButton("2"),
                          _buildButton("3"),
                          _buildButton("+", color: Colors.orange),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          _buildButton("0", color: Color(0xFF333333)),
                          _buildButton("."),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.all(24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Text(
                                  "=",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () => _buttonPressed("="),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
