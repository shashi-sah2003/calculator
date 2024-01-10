import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _input = '';
  String _history = '';

  void _appendToInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void _calculate() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(_input);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);

      if (result % 1 == 0) {
        // Check if the result is an integer
        setState(() {
          _history = '$_input = ${result.toInt()}\n$_history';
          _input = result.toInt().toString();
        });
      } else {
        setState(() {
          _history = '$_input = $result\n$_history';
          _input = result.toString();
        });
      }
    } catch (error) {
      setState(() {
        _input = 'Error';
      });
    }
  }

  void _clearInput() {
    setState(() {
      _input = '';
    });
  }

  void _clearLastEntry() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }

  void _clearHistory() {
    setState(() {
      _history = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _history,
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  Text(
                    _input,
                    style: TextStyle(fontSize: 36.0),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildOperatorButton('/'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildOperatorButton('*'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildOperatorButton('-'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('0'),
              _buildDecimalButton(),
              _buildButton('='),
              _buildOperatorButton('+'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildClearButton(),
              _buildClearLastEntryButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return ElevatedButton(
      onPressed: () {
        if (text == '=') {
          _calculate();
        } else {
          _appendToInput(text);
        }
      },
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget _buildDecimalButton() {
    return ElevatedButton(
      onPressed: () {
        if (!_input.contains('.')) {
          _appendToInput('.');
        }
      },
      child: Text(
        '.',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget _buildOperatorButton(String text) {
    return ElevatedButton(
      onPressed: () => _appendToInput(text),
      style: ElevatedButton.styleFrom(primary: Colors.orange),
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        _clearInput();
        _clearHistory();
      },
      style: ElevatedButton.styleFrom(primary: Colors.red),
      child: Text(
        'C',
        style: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
    );
  }

  Widget _buildClearLastEntryButton() {
    return ElevatedButton(
      onPressed: _clearLastEntry,
      style: ElevatedButton.styleFrom(primary: Colors.grey),
      child: Text(
        'CE',
        style: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
    );
  }
}