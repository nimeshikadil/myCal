import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic displaytxt = '0'; // Displayed text   IM/2021/065
  String operator = ''; // Store current operator
  String history = ''; // Calculation history
  List<String> calculationHistory = []; // Store history of calculations

  double numOne = 0;
  double numTwo = 0;
  String result = '';
  bool isResultDisplayed = false; // To track if result is displayed

  // Button Widget IM/2021/065
  Widget calcButton(dynamic btnContent, Color btnColor, Color txtColor) {
    return Container(
      width: 65,
      height: 65,
      child: ElevatedButton(
        onPressed: () {
          calculation(btnContent);
        },
        child: btnContent is String
            ? Text(
                btnContent,
                style: TextStyle(fontSize: 22, color: txtColor),
              )
            : Icon(
                btnContent,
                color: txtColor,
                size: 24,
              ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(10),
          backgroundColor: btnColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              _showHistoryDialog(context); // Show history when icon is pressed
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display Screen IM/2021/065
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Shows the calculation history at the top IM/2021/065
                  Text(
                    history,
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  SizedBox(height: 5),

                  // Wrap the display text with SingleChildScrollView IM/2021/065
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      displaytxt.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            // Button Rows IM/2021/065
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('AC', Colors.grey, Colors.black),
                calcButton('√', Colors.grey, Colors.black),
                calcButton('%', Colors.grey, Colors.black),
                calcButton(
                    '/', const Color.fromARGB(255, 80, 105, 245), Colors.white),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('7', Colors.grey[850]!, Colors.white),
                calcButton('8', Colors.grey[850]!, Colors.white),
                calcButton('9', Colors.grey[850]!, Colors.white),
                calcButton(
                    'x', const Color.fromARGB(255, 80, 105, 245), Colors.white),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('4', Colors.grey[850]!, Colors.white),
                calcButton('5', Colors.grey[850]!, Colors.white),
                calcButton('6', Colors.grey[850]!, Colors.white),
                calcButton(
                    '-', const Color.fromARGB(255, 80, 105, 245), Colors.white),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('1', Colors.grey[850]!, Colors.white),
                calcButton('2', Colors.grey[850]!, Colors.white),
                calcButton('3', Colors.grey[850]!, Colors.white),
                calcButton(
                    '+', const Color.fromARGB(255, 80, 105, 245), Colors.white),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('0', Colors.grey[850]!, Colors.white),
                calcButton('.', Colors.grey[850]!, Colors.white),
                calcButton(
                    Icons.backspace_outlined, Colors.grey[850]!, Colors.white),
                calcButton('=', const Color.fromARGB(255, 80, 105, 245), Colors.white),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Show History Dialog  IM/2021/065
  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Calculation History',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: calculationHistory.isEmpty
                  ? [
                      Text('No history yet.',
                          style: TextStyle(color: Colors.white))
                    ]
                  : calculationHistory
                      .map((historyItem) => Text(
                            historyItem,
                            style: TextStyle(color: Colors.white),
                          ))
                      .toList(),
            ),
          ),
          actions: [
            // Clear History Button  IM/2021/065
            TextButton(
              onPressed: () {
                setState(() {
                  calculationHistory.clear(); // Clear the history
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Clear History',
                style: TextStyle(color: Colors.white),
              ),
            ),

            // Close Button IM/2021/065
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  // Calculator logics IM/2021/065
  void calculation(dynamic btnContent) {
    if (btnContent == 'AC') {
      displaytxt = '0';
      history = '';
      numOne = 0;
      numTwo = 0;
      operator = '';
    } else if (btnContent == Icons.backspace_outlined) {
      if (displaytxt.length > 1) {
        displaytxt = displaytxt.substring(0, displaytxt.length - 1);
      } else {
        displaytxt = '0';
      }
    } else if (btnContent == '√') {
      double number = double.tryParse(displaytxt) ?? 0;
      if (number < 0) {
        displaytxt = 'Invalid input: Cannot calculate square root of a negative number';
        history = '√($number)';
      } else {
        double result = sqrt(number);
        history = '√($number)';
        displaytxt = result.toString();
        calculationHistory.add('$history = $displaytxt');
      }
      isResultDisplayed = true; // Set flag to true after displaying result
    } else if (btnContent == '%') {
      double number = double.parse(displaytxt);
      double result = number / 100;
      history = '$number%';
      displaytxt = result.toString();
      calculationHistory.add('$history = $displaytxt');
      isResultDisplayed = true; // Set flag to true after displaying result
    } else if (btnContent == '+' ||
        btnContent == '-' ||
        btnContent == 'x' ||
        btnContent == '/') {
      if (numOne == 0) {
        numOne = double.parse(displaytxt);
        operator = btnContent;
        history = '$numOne $operator';
        displaytxt =
            '0'; // Set to zero when operator is pressed, so user can enter the next number
      } else {
        numTwo = double.parse(displaytxt);
        double result = 0;

        if (operator == '+') result = numOne + numTwo;
        if (operator == '-') result = numOne - numTwo;
        if (operator == 'x') result = numOne * numTwo;
        if (operator == '/') {
          if (numTwo == 0) {
            if (numOne == 0) {
              displaytxt = 'Can not divide by zero';
              history = '0 / 0';
            } else {
              displaytxt = 'Can not divide by zero';
              history = '$numOne / 0';
            }
          } else {
            result = numOne / numTwo;
            history = '$numOne $operator $numTwo';
            displaytxt = result.toString();
          }
        }

        if (operator != '/') {
          history = '$numOne $operator $numTwo';
          displaytxt = result.toString();
        }

        calculationHistory.add('$history = $displaytxt');

        numOne = result;
        operator = btnContent;
        history = '$numOne $operator';
        displaytxt =
            '0'; // Set to zero when operator is pressed, so user can enter the next number
      }
    } else if (btnContent == '=') {
      numTwo = double.parse(displaytxt);
      double result = 0;

      if (operator == '+') result = numOne + numTwo;
      if (operator == '-') result = numOne - numTwo;
      if (operator == 'x') result = numOne * numTwo;
      if (operator == '/') {
        if (numTwo == 0) {
          if (numOne == 0) {
            displaytxt = 'Can not divide by zero';
            history = '0 / 0';
          } else {
            displaytxt = 'Can not divide by zero';
            history = '$numOne / 0';
          }
        } else {
          result = numOne / numTwo;
          history = '$numOne $operator $numTwo';
          displaytxt = result.toString();
        }
      }

      if (operator != '/') {
        history = '$numOne $operator $numTwo';
        displaytxt = result.toString();
      }

      calculationHistory.add('$history = $displaytxt');

      numOne = result;
      operator = '';
      isResultDisplayed = true; // Set flag to true after displaying result
    } else {
      if (displaytxt == '0' || isResultDisplayed) {
        displaytxt = btnContent.toString();
        isResultDisplayed =
            false; // Reset flag when user starts entering a new number
      } else {
        displaytxt += btnContent.toString();
      }
    }
    setState(() {});
  }
}