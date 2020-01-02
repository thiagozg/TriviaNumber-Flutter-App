import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:trivia_number/core/error/exceptions.dart';
import 'package:trivia_number/features/main/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivia_number/features/main/data/models/number_trivia_response.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client { }

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  final jsonString = fixture('trivia_normal');
  final numberTriviaResponse = NumberTriviaResponse.fromJson(jsonDecode(jsonString));

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(jsonString, HttpStatus.ok));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Error', HttpStatus.notFound));
  }
  
  group('getConcreteNumberTrivia', () {
    final number = 1;
    
    test(
      '''should perform a GET request on a URL with number being 
      the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getConcreteNumberTrivia(number);
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/$number',
          headers: {
            'Content-Type': 'application/json'
          }
        ));
      }
    );

    test(
      'should return NumberTriviaResponse when the response code is 200 (HTTP/OK)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(number);
        // assert
        expect(result, equals(numberTriviaResponse));
      }
    );

    test(
      'should throw a ServerException when the response status code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(number), throwsA(isInstanceOf<ServerException>()));
      }
    );

  });

  group('getRandomNumberTrivia', () {
    test(
      'should preform a GET request on a URL with *random* endpoint with application/json header',
          () {
        //arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getRandomNumberTrivia();
        // assert
        expect(result, equals(numberTriviaResponse));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getRandomNumberTrivia;
        // assert
        expect(() => call(), throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
  
}