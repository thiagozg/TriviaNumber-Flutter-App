import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/features/main/data/models/number_trivia_response.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaResponse] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaResponse> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaResponse triviaToCache);
}

const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaResponse> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaResponse.fromJson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaResponse triviaToCache) {
    return sharedPreferences.setString(
        cachedNumberTrivia,
        jsonEncode(triviaToCache.toJson())
    );
  }

}