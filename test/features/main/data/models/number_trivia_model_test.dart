import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:trivia_number/features/main/data/models/number_trivia_response.dart';
import 'package:trivia_number/features/main/domain/entities/number_trivia_bo.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final numberTriviaResponse = NumberTriviaResponse(number: 1, text: 'Test Text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      expect(numberTriviaResponse, isA<NumberTriviaBO>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_dumb'));
        // act
        final result = NumberTriviaResponse.fromJson(jsonMap);
        // assert
        expect(result, equals(numberTriviaResponse));
      },
    );

    test(
      'should return a valid model when the JSON number is regardade as a double',
      () async {
        // arrange
        final numberTriviaResponseDouble = NumberTriviaResponse(number: 3.14, text: 'PI');
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double'));
        // act
        final result = NumberTriviaResponse.fromJson(jsonMap);
        // assert
        expect(result, equals(numberTriviaResponseDouble));
      },
    );

    test(
      'should return a valid model when the JSON number is regardade as a double (with scientific notation)',
      () async {
        // arrange
        final numberTriviaResponseDouble = NumberTriviaResponse(number: 6.022e+23, text: '6.022e+23 is the number of molecules in one mole of any substance (Avogadro\'s number).');
        final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_scientific_notation'));
        // act
        final result = NumberTriviaResponse.fromJson(jsonMap);
        // assert
        expect(result, equals(numberTriviaResponseDouble));
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = numberTriviaResponse.toJson();
        
        // assert
        final expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
