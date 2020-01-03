import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/usecases/no_params.dart';
import 'package:trivia_number/core/util/input_converter.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';
import 'package:trivia_number/features/main/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/main/domain/usecases/get_random_number_trivia.dart';
import 'package:trivia_number/features/main/presentation/bloc/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTriviaUseCase { }
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTriviaUseCase { }
class MockInputConverter extends Mock implements InputConverter { }

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter
    );
  });

  test('initialState should be EmptyState', () {
    expect(bloc.initialState, equals(EmptyState()));
  });

  group('GetTriviaForConcreNumber', () {
    final numberString = '1';
    final numberParsed = 1;
    final numberTriviaBo = NumberTriviaBO(number: 1, text: 'test');

    void setupMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(numberParsed));
    }

    void setupMockGetConcreteNumberTriviaSuccess() {
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTriviaBo));
    }

    test(
        'should call the [InputConverter] to validate and convert the string to an unsigned integer',
            () async {
          // arrange
          setupMockInputConverterSuccess();
          // act
          bloc.dispatch(GetTriviaForConcreteNumberEvent(numberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          // assert
          verify(mockInputConverter.stringToUnsignedInteger(numberString));
        }
    );

    test(
        'should emit [ErrorState] when the input is invalid',
            () async {
          // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));

          // assert later (being safe in case the dispatcher execute too fast)
          var expected = [
            EmptyState(),
            ErrorState(message: invalidInputFailureMessage)
          ];
          expectLater(bloc.state, emitsInOrder(expected));

          // act
          bloc.dispatch(GetTriviaForConcreteNumberEvent(numberString));
        }
    );

    test(
        'should get data from the concrete use case',
            () async {
          // arrange
          setupMockInputConverterSuccess();
          setupMockGetConcreteNumberTriviaSuccess();
          // act
          bloc.dispatch(GetTriviaForConcreteNumberEvent(numberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
          // assert
          verify(mockGetConcreteNumberTrivia(Params(number: numberParsed)));
        }
    );

    test(
        'should emit [LoadingState, LoadedState] when data is gotten successfully',
            () async {
          // arrange
          setupMockInputConverterSuccess();
          setupMockGetConcreteNumberTriviaSuccess();
          // assert later (cuz is testing streams)
          final expected = [
            EmptyState(),
            LoadingState(),
            LoadedState(triviaBO: numberTriviaBo)
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumberEvent(numberString));
        }
    );

    test(
        'should emit [LoadingState, ErrorState] when data fails (with server error message)',
            () async {
          // arrange
          setupMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later (cuz is testing streams)
          final expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: serverFailureMessage)
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumberEvent(numberString));
        }
    );

    test(
        'should emit [LoadingState, ErrorState] when data fails (with cache error message)',
            () async {
          // arrange
          setupMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later (cuz is testing streams)
          final expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: cacheFailureMessage)
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForConcreteNumberEvent(numberString));
        }
    );
  });

  group('GetTriviaForRandomNumber', () {
    final numberTriviaBo = NumberTriviaBO(number: 1, text: 'test');

    void setupMockGetRandomNumberTriviaSuccess() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTriviaBo));
    }

    test(
        'should get data from the random use case',
            () async {
          // arrange
          setupMockGetRandomNumberTriviaSuccess();
          // act
          bloc.dispatch(GetTriviaForRandomNumberEvent());
          await untilCalled(mockGetRandomNumberTrivia(any));
          // assert
          verify(mockGetRandomNumberTrivia(NoParams()));
        }
    );

    test(
        'should emit [LoadingState, LoadedState] when data is gotten successfully',
            () async {
          // arrange
          setupMockGetRandomNumberTriviaSuccess();
          // assert later (cuz is testing streams)
          final expected = [
            EmptyState(),
            LoadingState(),
            LoadedState(triviaBO: numberTriviaBo)
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForRandomNumberEvent());
        }
    );

    test(
        'should emit [LoadingState, ErrorState] when data fails (with server error message)',
            () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          // assert later (cuz is testing streams)
          final expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: serverFailureMessage)
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForRandomNumberEvent());
        }
    );

    test(
        'should emit [LoadingState, ErrorState] when data fails (with cache error message)',
            () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later (cuz is testing streams)
          final expected = [
            EmptyState(),
            LoadingState(),
            ErrorState(message: cacheFailureMessage)
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.dispatch(GetTriviaForRandomNumberEvent());
        }
    );
  });

}
