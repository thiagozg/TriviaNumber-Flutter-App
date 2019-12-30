import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:trivia_number/core/usecases/no_params.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

import 'package:trivia_number/features/main/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_number/features/main/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivia_number/features/main/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetRandomNumberTriviaUseCase useCase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTriviaUseCase(mockNumberTriviaRepository);
  });
  
  final numberTrivia = NumberTriviaBO(number: 1, text: 'testing...');

  test(
    'should get trivia random number form the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(numberTrivia));
      
      // act
      final result = await useCase();
      
      // assert
      expect(result, Right(numberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}