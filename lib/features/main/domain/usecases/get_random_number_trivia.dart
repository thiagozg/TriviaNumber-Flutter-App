import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase implements UseCase<NoParams, NumberTrivia> {

  final NumberTriviaRepository repository;

  GetRandomNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call([
    NoParams params
  ]) async => await repository.getRandomNumberTrivia();

}