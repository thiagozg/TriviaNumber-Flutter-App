import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class NumberTriviaBO extends Equatable {
  final String text;
  final double number;

  NumberTriviaBO({
    @required this.text, 
    @required this.number
  });

  @override
  List<Object> get props => [text, number];

}