// lib/screens/calculator/calculator_screen.dart

import 'package:flutter/material.dart';

import '../../models/calculation_history.dart';
import '../history/history_screen.dart';
import '../home/home_screen.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _output = "0";
  String _currentNumber = "";
  String _operation = "";
  double _num1 = 0;
  double _num2 = 0;
  bool _shouldClearCurrent = false;
  List<CalculationItem> _history = [];
  String _currentExpression = "";
  String _displayExpression = "";

  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  String _lastPressedButton = "";

  // Colors
  final Color _primaryColor = Colors.black;
  final Color _accentColor = Colors.orange;
  final Color _buttonColor = const Color(0xFF333333);
  final Color _textColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      _lastPressedButton = buttonText;
      _buttonController.forward().then((_) => _buttonController.reverse());

      switch (buttonText) {
        case "C":
          _resetCalculator();
          break;
        case "⌫":
          _handleBackspace();
          break;
        case "+/-":
          _toggleSign();
          break;
        case ".":
          _addDecimalPoint();
          break;
        case "=":
          if (_operation.isNotEmpty) _calculateResult();
          break;
        default:
          if (_isOperator(buttonText)) {
            _handleOperator(buttonText);
          } else {
            _handleNumber(buttonText);
          }
      }
    });
  }

  void _resetCalculator() {
    _output = "0";
    _currentNumber = "";
    _operation = "";
    _num1 = 0;
    _num2 = 0;
    _currentExpression = "";
    _displayExpression = "";
  }

  void _handleBackspace() {
    if (_currentNumber.isNotEmpty) {
      _currentNumber = _currentNumber.substring(0, _currentNumber.length - 1);
      if (_currentNumber.isEmpty) _currentNumber = "0";
      _output = _currentNumber;
    }
  }

  void _toggleSign() {
    if (_currentNumber.startsWith("-")) {
      _currentNumber = _currentNumber.substring(1);
    } else {
      _currentNumber = "-$_currentNumber";
    }
    _output = _currentNumber;
  }

  void _addDecimalPoint() {
    if (!_currentNumber.contains(".")) {
      _currentNumber = _currentNumber.isEmpty ? "0." : "$_currentNumber.";
      _output = _currentNumber;
    }
  }

  bool _isOperator(String text) {
    return ["+", "-", "×", "÷", "%"].contains(text);
  }

  void _handleOperator(String operator) {
    if (_currentNumber.isNotEmpty) {
      if (_operation.isEmpty) {
        _num1 = double.parse(_currentNumber);
      } else {
        _num2 = double.parse(_currentNumber);
        _num1 = _calculate();
      }
      _operation = operator;
      _displayExpression = "${_formatNumber(_num1)} $_operation ";
      _currentNumber = "";
    }
  }

  void _handleNumber(String number) {
    if (_shouldClearCurrent) {
      _currentNumber = number;
      _shouldClearCurrent = false;
    } else {
      _currentNumber = _currentNumber == "0" ? number : _currentNumber + number;
    }
    _output = _currentNumber;
  }

  void _calculateResult() {
    _num2 = double.parse(_currentNumber);
    double result = _calculate();
    String resultString = _formatNumber(result);

    _history.add(
      CalculationItem(
        expression: _displayExpression + _currentNumber,
        result: resultString,
        timestamp: DateTime.now(),
      ),
    );

    setState(() {
      _output = resultString;
      _currentNumber = resultString;
      _operation = "";
      _currentExpression = "";
      _displayExpression = "";
    });
  }

  String _formatNumber(double number) {
    String numStr = number.toString();
    return numStr.endsWith(".0")
        ? numStr.substring(0, numStr.length - 2)
        : numStr;
  }

  double _calculate() {
    switch (_operation) {
      case "+":
        return _num1 + _num2;
      case "-":
        return _num1 - _num2;
      case "×":
        return _num1 * _num2;
      case "÷":
        return _num1 / _num2;
      case "%":
        return _num1 % _num2;
      default:
        return _num2;
    }
  }

  Widget _buildButton(
    String buttonText, {
    Color? backgroundColor,
    Color? textColor,
    double flex = 1,
  }) {
    return Expanded(
      flex: flex.toInt(),
      child: AnimatedBuilder(
        animation: _buttonAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale:
                _lastPressedButton == buttonText ? _buttonAnimation.value : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor ?? _buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.all(24),
                ),
                onPressed: () => _buttonPressed(buttonText),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 28,
                    color: textColor ?? _textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: _accentColor,
            size: 28,
          ),
          onPressed: _navigateToHome,
        ),
        title: Text(
          'Calculator',
          style: TextStyle(
            color: _textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.history,
                color: _accentColor,
                size: 28,
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistoryScreen(
                      history: _history,
                      onClearHistory: _clearHistory,
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
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    _displayExpression,
                    style: TextStyle(
                      fontSize: 28,
                      color: _textColor.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _output,
                    style: TextStyle(
                      fontSize: 52,
                      color: _textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton("C",
                        backgroundColor: _accentColor.withOpacity(0.2),
                        textColor: _accentColor),
                    _buildButton("⌫",
                        backgroundColor: _accentColor.withOpacity(0.2),
                        textColor: _accentColor),
                    _buildButton("%",
                        backgroundColor: _accentColor.withOpacity(0.2),
                        textColor: _accentColor),
                    _buildButton("÷", textColor: _accentColor),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("×", textColor: _accentColor),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("-", textColor: _accentColor),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("+", textColor: _accentColor),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("+/-"),
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton("=",
                        backgroundColor: _accentColor, textColor: _textColor),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
