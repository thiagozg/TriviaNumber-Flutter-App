import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/usecases/usecase.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';
import 'package:trivia_number/features/main/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase implements UseCase<Params, NumberTriviaBO> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTriviaBO>> call([
    Params params
  ]) async => await repository.getConcreteNumberTrivia(params.number);

}

class Params extends Equatable {
  final int number;

  Params({@required this.number});

  @override
  List<Object> get props => [number];  
}
