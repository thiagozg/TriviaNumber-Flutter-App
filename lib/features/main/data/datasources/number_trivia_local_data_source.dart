import 'package:trivia_number/features/main/data/models/number_trivia_response.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaResponse] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaResponse> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaResponse triviaToCache);
}