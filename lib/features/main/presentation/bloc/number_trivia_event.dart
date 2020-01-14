import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sealed_unions/sealed_unions.dart';

@immutable
class NumberTriviaEvent extends Union2Impl<_GetTriviaForConcreteNumberEvent,
    _GetTriviaForRandomNumberEvent> {

  static final _factory = const Doublet<_GetTriviaForConcreteNumberEvent,
      _GetTriviaForRandomNumberEvent>();

  NumberTriviaEvent._(Union2<_GetTriviaForConcreteNumberEvent,
      _GetTriviaForRandomNumberEvent> union) : super(union);

  factory NumberTriviaEvent.concreteNumber(String number) =>
      NumberTriviaEvent._(_factory.first(_GetTriviaForConcreteNumberEvent(number)));

  factory NumberTriviaEvent.randomNumber() =>
      NumberTriviaEvent._(_factory.second(_GetTriviaForRandomNumberEvent()));
}

class _GetTriviaForConcreteNumberEvent extends Equatable {
  final String number;

  _GetTriviaForConcreteNumberEvent(this.number);

  @override
  List<Object> get props => [number];
}

class _GetTriviaForRandomNumberEvent extends Equatable {
  @override
  List<Object> get props => null;
}