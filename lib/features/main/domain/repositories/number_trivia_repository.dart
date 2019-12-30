import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia_bo.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTriviaBO>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTriviaBO>> getRandomNumberTrivia();
}