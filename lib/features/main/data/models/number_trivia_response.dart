import 'package:flutter/foundation.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

class NumberTriviaResponse extends NumberTriviaBO {
  NumberTriviaResponse({
    @required String text,
    @required double number
  }) : super(text: text, number: number);

  NumberTriviaResponse.intNumber({
    @required String text,
    @required int number
  }) : super(text: text, number: number.toDouble());

  factory NumberTriviaResponse.fromJson(Map<String, dynamic> json) {
    return NumberTriviaResponse(
      text: json['text'],
      number: (json['number'] as num).toDouble()
    );
  }

  Map<String, dynamic> toJson() => {
    'text': this.text,
    'number': this.number
  };
}