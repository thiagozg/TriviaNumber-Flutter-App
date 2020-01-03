import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NumberTriviaBO extends Equatable {
  final String text;
  final double number;

  NumberTriviaBO({
    @required this.number,
    @required this.text
  });

  @override
  List<Object> get props => [text, number];

}