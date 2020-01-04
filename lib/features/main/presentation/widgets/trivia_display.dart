import 'package:flutter/material.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTriviaBO numberTriviaBO;

  const TriviaDisplay({
    Key key,
    @required this.numberTriviaBO,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
              numberTriviaBO.number.toString(),
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTriviaBO.text,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}