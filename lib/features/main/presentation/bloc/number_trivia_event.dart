import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String number;

  GetTriviaForConcreteNumberEvent(this.number);

  @override
  List<Object> get props => [number];
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {
  @override
  List<Object> get props => null;
}