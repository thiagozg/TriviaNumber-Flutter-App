import 'package:dartz/dartz.dart';
import 'package:trivia_number/core/error/failures.dart';

abstract class UseCase<Params, Type> {
  Future<Either<Failure, Type>> call([Params params]);
}