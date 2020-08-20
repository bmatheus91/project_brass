import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:http/http.dart' as http;

import 'package:project_brass/core/error/exceptions.dart';
import 'package:project_brass/features/number_trivia/infrastucture/datasource/number_trivia_remote_data_source.dart';
import 'package:project_brass/features/number_trivia/infrastucture/models/number_trivia_model.dart';

import '../../../../fixture/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSource remoteDataSource;
  MockHttpClient mockClient;

  void setUpMockHttpClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  setUp(() {
    mockClient = MockHttpClient();
    remoteDataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  group('getConcreteNumberTrivia', () {
    final number = 1;
    final triviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
        'should preform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
      setUpMockHttpClientSuccess200();

      remoteDataSource.getConcreteNumberTrivia(number);

      verify(mockClient.get('http://numbersapi.com/$number',
          headers: {HttpHeaders.contentTypeHeader: 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200();

      final response = await remoteDataSource.getConcreteNumberTrivia(number);

      expect(response, equals(triviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      setUpMockHttpClientFailure404();

      final call = remoteDataSource.getConcreteNumberTrivia;

      expect(() => call(number), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final triviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test(
      'should preform a GET request on a URL with *random* endpoint with application/json header',
      () {
        setUpMockHttpClientSuccess200();

        remoteDataSource.getRandomNumberTrivia();

        verify(mockClient.get(
          'http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
      () async {
        setUpMockHttpClientSuccess200();

        final result = await remoteDataSource.getRandomNumberTrivia();

        expect(result, equals(triviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        setUpMockHttpClientFailure404();

        final call = remoteDataSource.getRandomNumberTrivia;

        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
