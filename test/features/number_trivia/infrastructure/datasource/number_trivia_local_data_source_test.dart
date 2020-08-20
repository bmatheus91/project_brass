import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixture/fixture_reader.dart';

import 'package:project_brass/core/error/exceptions.dart';
import 'package:project_brass/features/number_trivia/infrastucture/models/number_trivia_model.dart';
import 'package:project_brass/features/number_trivia/infrastucture/datasource/number_trivia_local_data_source.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl localDataSource;

  MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final model =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      when(sharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await localDataSource.getLastNumberTrivia();

      verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(model));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      when(sharedPreferences.getString(any)).thenReturn(null);

      expect(() async => await localDataSource.getLastNumberTrivia(),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final model =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test('should call SharedPreferences to cache the data', () async {
      localDataSource.cacheNumberTrivia(model);

      final expectedJson = json.encode(model.toJson());

      verify(sharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJson));
    });
  });
}
