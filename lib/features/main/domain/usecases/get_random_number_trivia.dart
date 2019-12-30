import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia_bo.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase implements UseCase<NoParams, NumberTriviaBO> {

  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTriviaBO>> call([
    NoParams params
  ]) async => await repository.getRandomNumberTrivia();

}