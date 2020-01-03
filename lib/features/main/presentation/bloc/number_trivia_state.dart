import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class EmptyState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class LoadingState extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class LoadedState extends NumberTriviaState {
  final NumberTriviaBO triviaBO;

  LoadedState({@required this.triviaBO});

  @override
  List<Object> get props => [triviaBO];
}

class ErrorState extends NumberTriviaState {
  final String message;

  ErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
