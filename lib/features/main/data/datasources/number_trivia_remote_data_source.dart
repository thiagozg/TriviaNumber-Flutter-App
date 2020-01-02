
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:trivia_number/core/error/exceptions.dart';

import '../models/number_trivia_response.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaResponse> getConcreteNumberTrivia(num number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaResponse> getRandomNumberTrivia();
}

const url = 'http://numbersapi.com/';
const Map<String, String> headersDefault = {
  'Content-Type': 'application/json'
};

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({@required this.client});

  @override
  Future<NumberTriviaResponse> getConcreteNumberTrivia(num number) async =>
      _getTriviaFromUrl('$url$number');

  @override
  Future<NumberTriviaResponse> getRandomNumberTrivia() async =>
      _getTriviaFromUrl('${url}random');

  Future<NumberTriviaResponse> _getTriviaFromUrl(String url) async {
    final response = await client.get(url, headers: headersDefault);

    if (response.statusCode == 200) {
      return NumberTriviaResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

}