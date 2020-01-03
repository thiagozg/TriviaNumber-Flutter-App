import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/usecases/no_params.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';
import 'package:trivia_number/features/main/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/main/domain/usecases/get_random_number_trivia.dart';

import 'bloc.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String unexpectedFailureMessage = 'Unexpected error';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTriviaUseCase concrete,
    @required GetRandomNumberTriviaUseCase random,
    @required this.inputConverter
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTriviaUseCase = concrete,
        getRandomNumberTriviaUseCase = random;

  @override
  NumberTriviaState get initialState => EmptyState();

  @override
  Stream<NumberTriviaState> mapEventToState(
      NumberTriviaEvent event,
  ) async* {
    // TODO: use union...
    if (event is GetTriviaForConcreteNumberEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.number);

      // every time yield something, is going to emit the state
      yield* inputEither.fold(_onFailureInputConverter, _onSuccessInputConverter);
    } else if (event is GetTriviaForRandomNumberEvent) {
      yield LoadingState();
      final failureOrTrivia = await getRandomNumberTriviaUseCase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _onSuccessInputConverter(integer) async* {
    // emitting state before do the network or cache request
    yield LoadingState();
    final failureOrTrivia = await getConcreteNumberTriviaUseCase(Params(number: integer));
    yield* _eitherLoadedOrErrorState(failureOrTrivia);
  }

  Stream<NumberTriviaState> _onFailureInputConverter(failure) async* {
    yield ErrorState(message: invalidInputFailureMessage);
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTriviaBO> either
  ) async* {
    yield either.fold(
        (failure) => ErrorState(message: failure.mapToMessage()),
        (trivia) => LoadedState(triviaBO: trivia)
    );
  }
}

extension _BlocFailure on Failure {
  String mapToMessage() {
    switch (this.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return unexpectedFailureMessage;
    }
  }
}
