import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project_brass/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:project_brass/features/number_trivia/infrastucture/models/number_trivia_model.dart';

import '../../../../fixture/fixture_reader.dart';

void main() {
  final model = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a subclass of NumberTrivia entity', () async {
    expect(model, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer',
        () async {
      final map = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(map);

      expect(result, model);
    });

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, model);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        final result = model.toJson();

        final map = {"text": "Test Text", "number": 1};

        expect(result, map);
      },
    );
  });
}
