import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';
import '../../../../core/error/exceptions.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences preferences;

  NumberTriviaLocalDataSourceImpl(this.preferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) => preferences
      .setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = preferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString == null || jsonString.isEmpty) {
      throw CacheException();
    }

    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }
}
