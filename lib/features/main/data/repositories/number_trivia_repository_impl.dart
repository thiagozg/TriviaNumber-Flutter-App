import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/core/error/failures.dart';
import 'package:trivia_number/core/network/network_info.dart';
import 'package:trivia_number/features/main/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/main/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';
import 'package:trivia_number/features/main/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTriviaBO> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTriviaBO>> getConcreteNumberTrivia(
      num number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTriviaBO>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  // typedef to refactor this code as parameter:
  // Future<NumberTriviaBO> Function() getConcreteOrRandom
  Future<Either<Failure, NumberTriviaBO>> _getTrivia(
    _ConcreteOrRandomChooser getConcreteOrRandom
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
