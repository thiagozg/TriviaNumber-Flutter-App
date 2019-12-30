import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

import 'package:trivia_number/features/main/domain/repositories/number_trivia_repository.dart';
import 'package:trivia_number/features/main/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository;
  GetConcreteNumberTriviaUseCase useCase;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
  });
  
  final number = 1;
  final numberTrivia = NumberTriviaBO(number: 1, text: 'testing...');

  test(
    'should get trivia for the number form the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => Right(numberTrivia));
      
      // act
      final result = await useCase(Params(number: number));
      
      // assert
      expect(result, Right(numberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(number));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}