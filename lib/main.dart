import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';

  final myTextStyle = TextStyle(fontSize: 30, color: Colors.deepPurple[900]);

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '9',
    '8',
    '7',
    'x',
    '6',
    '5',
    '4',
    '-',
    '3',
    '2',
    '1',
    '+',
    '0',
    '.',
    'ANS',
    '=',
  ];

  bool isOperator(String x) {
    if (x == '%' || x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    } else {
      return false;
    }
  }

  void equalPressed() {
    String finalQuestion = userQuestion;
    finalQuestion = finalQuestion.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finalQuestion);

    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    userAnswer = eval.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      userQuestion,
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.centerRight,
                    child: Text(
                      userAnswer,
                      style: myTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                  child: GridView.builder(
                      shrinkWrap: true,
                      primary: true,
                      itemCount: buttons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (BuildContext context, int index) {
                        if (buttons[index] == 'C') {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                userQuestion = '';
                                userAnswer = '';
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors.green,
                            textColor: Colors.white,
                          );
                        } else if (buttons[index] == 'DEL') {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                String str = userQuestion;
                                if (str.length > 0) {
                                  userQuestion =
                                      str.substring(0, str.length - 1);
                                }
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors.red,
                            textColor: Colors.white,
                          );
                        } else if (buttons[index] == '=') {
                          return MyButton(
                            buttonTapped: () {
                              setState(() {
                                equalPressed();
                              });
                            },
                            buttonText: buttons[index],
                            color: Colors.deepPurple,
                            textColor: Colors.white,
                          );
                        } else {
                          return MyButton(
                            buttonTapped: () {
                              String inputStr = buttons[index];
                              bool isFirst =
                                  userQuestion.length == 0 ? true : false;
                              String lastStr;
                              if (!isFirst) {
                                lastStr = userQuestion
                                    .substring(userQuestion.length - 1);
                              }

                              if (isFirst && isOperator(inputStr)) return;
                              if (isFirst && inputStr == '.') return;

                              if (isOperator(inputStr) && isOperator(lastStr))
                                return;
                              if (inputStr == '.' &&
                                  userQuestion.indexOf('.') != -1) return;
                              setState(() {
                                if (buttons[index] == 'ANS') {
                                  equalPressed();
                                } else {
                                  userQuestion += buttons[index];
                                }
                              });
                            },
                            buttonText: buttons[index],
                            color: isOperator(buttons[index])
                                ? Colors.deepPurple
                                : Colors.deepPurple[50],
                            textColor: isOperator(buttons[index])
                                ? Colors.white
                                : Colors.deepPurple,
                          );
                        }
                      })),
            ),
          ),
        ],
      ),
    );
  }
}
