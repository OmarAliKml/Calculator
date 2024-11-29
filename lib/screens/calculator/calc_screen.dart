import 'package:flutter/material.dart';
import '../../models/calculation_history.dart';
import '../history/history_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _currentNumber = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;
  bool _shouldClearCurrent = false;
  List<CalculationItem> _history = [];
  String _currentExpression = "";
  String _lastPressedButton = "";
  String _displayExpression = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
        _currentNumber = "";
        _operation = "";
        _num1 = 0;
        _num2 = 0;
        _currentExpression = "";
        _displayExpression = "";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (_currentNumber.isNotEmpty) {
          _num1 = double.parse(_currentNumber);
          _operation = buttonText;
          _displayExpression = _currentNumber + " " + buttonText;
          _currentExpression = _currentNumber + " " + buttonText;
          _currentNumber = "";
        }
      } else if (buttonText == "=") {
        if (_currentNumber.isNotEmpty && _operation.isNotEmpty) {
          _num2 = double.parse(_currentNumber);
          _displayExpression = _currentExpression + " " + _currentNumber;
          _currentExpression += " " + _currentNumber;
          String result;
          switch (_operation) {
            case "+":
              result = _formatNumber((_num1 + _num2).toString());
              break;
            case "-":
              result = _formatNumber((_num1 - _num2).toString());
              break;
            case "×":
              result = _formatNumber((_num1 * _num2).toString());
              break;
            case "÷":
              if (_num2 != 0) {
                result = _formatNumber((_num1 / _num2).toString());
              } else {
                result = "Error";
              }
              break;
            default:
              result = "Error";
          }
          _history.add(CalculationItem(
            expression: _currentExpression,
            result: result,
            timestamp: DateTime.now(),
          ));
          _output = result;
          _currentNumber = result;
          _operation = "";
          _currentExpression = "";
          _displayExpression = "";
          _shouldClearCurrent = true;
        }
      } else if (buttonText == ".") {
        if (!_currentNumber.contains(".")) {
          _currentNumber = _currentNumber.isEmpty ? "0." : _currentNumber + ".";
          _output = _currentNumber;
          if (_operation.isEmpty) {
            _displayExpression = _currentNumber;
          } else {
            _displayExpression = _currentExpression + " " + _currentNumber;
          }
        }
      } else if (buttonText == "±") {
        if (_currentNumber.isNotEmpty) {
          if (_currentNumber.startsWith("-")) {
            _currentNumber = _currentNumber.substring(1);
          } else {
            _currentNumber = "-" + _currentNumber;
          }
          _output = _currentNumber;
          if (_operation.isEmpty) {
            _displayExpression = _currentNumber;
          } else {
            _displayExpression = _currentExpression + " " + _currentNumber;
          }
        }
      } else if (buttonText == "%") {
        if (_currentNumber.isNotEmpty) {
          double number = double.parse(_currentNumber);
          _currentNumber = _formatNumber((number / 100).toString());
          _output = _currentNumber;
          if (_operation.isEmpty) {
            _displayExpression = _currentNumber;
          } else {
            _displayExpression = _currentExpression + " " + _currentNumber;
          }
        }
      } else {
        if (_shouldClearCurrent) {
          _currentNumber = buttonText;
          _shouldClearCurrent = false;
          _displayExpression = "";
        } else {
          _currentNumber += buttonText;
        }
        _output = _formatNumber(_currentNumber);
        if (_operation.isEmpty) {
          _displayExpression = _currentNumber;
        } else {
          _displayExpression = _currentExpression + " " + _currentNumber;
        }
      }
    });
  }

  Widget _buildButton(String buttonText, {Color? color}) {
    bool isPressed = _lastPressedButton == buttonText;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 150),
          tween: Tween<double>(
            begin: isPressed ? 0.95 : 1.0,
            end: isPressed ? 0.95 : 1.0,
          ),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? const Color(0xFF333333),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(20),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
            onPressed: () {
              setState(() {
                _lastPressedButton = buttonText;
                _buttonPressed(buttonText);
              });
              Future.delayed(const Duration(milliseconds: 150), () {
                if (mounted) {
                  setState(() {
                    _lastPressedButton = "";
                  });
                }
              });
            },
            child: Text(
              buttonText,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEqualsButton() {
    bool isPressed = _lastPressedButton == "=";

    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: TweenAnimationBuilder(
          duration: const Duration(milliseconds: 150),
          tween: Tween<double>(
            begin: isPressed ? 0.95 : 1.0,
            end: isPressed ? 0.95 : 1.0,
          ),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(20),
            ).copyWith(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.white.withOpacity(0.1);
                  }
                  return null;
                },
              ),
            ),
            onPressed: () {
              setState(() {
                _lastPressedButton = "=";
                _buttonPressed("=");
              });
              Future.delayed(const Duration(milliseconds: 150), () {
                if (mounted) {
                  setState(() {
                    _lastPressedButton = "";
                  });
                }
              });
            },
            child: const Text(
              "=",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  String _formatNumber(String number) {
    if (number.endsWith(".0")) {
      return number.substring(0, number.length - 2);
    }
    return number;
  }

  void _showHistory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryScreen(
          history: _history,
          onClearHistory: () {
            setState(() {
              _history.clear();
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _output = result;
        _currentNumber = result;
        _operation = "";
        _currentExpression = "";
        _displayExpression = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.orange,
            ),
            onPressed: _showHistory,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _displayExpression,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _output,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      _buildButton("C", color: Colors.orange),
                      _buildButton("±", color: Colors.orange),
                      _buildButton("%", color: Colors.orange),
                      _buildButton("÷", color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("7"),
                      _buildButton("8"),
                      _buildButton("9"),
                      _buildButton("×", color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("4"),
                      _buildButton("5"),
                      _buildButton("6"),
                      _buildButton("-", color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("1"),
                      _buildButton("2"),
                      _buildButton("3"),
                      _buildButton("+", color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton("0"),
                      _buildButton("."),
                      _buildEqualsButton(),
                    ],
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
