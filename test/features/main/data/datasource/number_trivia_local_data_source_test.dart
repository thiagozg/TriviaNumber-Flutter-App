import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/features/main/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivia_number/features/main/data/models/number_trivia_response.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences { }

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final mockJson = fixture('trivia_cached');
    final numberTriviaResponse = NumberTriviaResponse.fromJson(jsonDecode(mockJson));

    test(
        'should return NumberTriviaResponse from SharedPreferences when there is one in the cache',
            () async {
          // arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(mockJson);
          // act
          final result = await dataSource.getLastNumberTrivia();
          // assert
          verify(mockSharedPreferences.getString(cachedNumberTrivia));
          expect(result, equals(numberTriviaResponse));
        }
    );

    test(
      'should throw a CacheException when there ir not a cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia; // remove () and store the function to a variable
        // assert
        expect(() => call(), throwsA(isInstanceOf<CacheException>()));
        verify(mockSharedPreferences.getString(cachedNumberTrivia));
      }
    );

  });

  group('cacheNumberTrivia', () {
    final numberTriviaResponse = NumberTriviaResponse(number: 1, text: '1');
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // act
        dataSource.cacheNumberTrivia(numberTriviaResponse);
        // assert
        final expectedJsonString = jsonEncode(numberTriviaResponse.toJson());
        verify(mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString));
      }
    );
  });

}