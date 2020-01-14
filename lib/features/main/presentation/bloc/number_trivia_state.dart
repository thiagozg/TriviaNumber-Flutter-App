import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sealed_unions/sealed_unions.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

class NumberTriviaState extends Union4Impl<_EmptyState, _LoadingState,
    _LoadedState, _ErrorState> {

  static final _factory = const Quartet<_EmptyState, _LoadingState,
      _LoadedState, _ErrorState>();

  NumberTriviaState._(Union4<_EmptyState, _LoadingState,
      _LoadedState, _ErrorState> union) : super(union);
  
  factory NumberTriviaState.empty() =>
      NumberTriviaState._(_factory.first(_EmptyState()));

  factory NumberTriviaState.loading() =>
      NumberTriviaState._(_factory.second(_LoadingState()));

  factory NumberTriviaState.loaded(NumberTriviaBO triviaBO) =>
      NumberTriviaState._(_factory.third(_LoadedState(triviaBO: triviaBO)));

  factory NumberTriviaState.error(String message) =>
      NumberTriviaState._(_factory.fourth(_ErrorState(message: message)));
}

class _EmptyState extends Equatable {
  @override
  List<Object> get props => [];
}

class _LoadingState extends Equatable {
  @override
  List<Object> get props => [];
}

class _LoadedState extends Equatable {
  final NumberTriviaBO triviaBO;

  _LoadedState({@required this.triviaBO});

  @override
  List<Object> get props => [triviaBO];
}

class _ErrorState extends Equatable {
  final String message;

  _ErrorState({@required this.message});

  @override
  List<Object> get props => [message];
}
