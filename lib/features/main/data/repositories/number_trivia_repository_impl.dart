import 'package:dartz/dartz.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';
import 'package:trivia_number/features/main/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTriviaBO>> getConcreteNumberTrivia(int number) {
    // TODO: implement getConcreteNumberTrivia
    return null;
  }

  @override
  Future<Either<Failure, NumberTriviaBO>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}