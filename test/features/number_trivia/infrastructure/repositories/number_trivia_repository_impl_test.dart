import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project_brass/core/error/exceptions.dart';
import 'package:project_brass/core/error/failures.dart';
import 'package:project_brass/core/network/network_info.dart';
import 'package:project_brass/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:project_brass/features/number_trivia/infrastucture/datasource/number_trivia_local_data_source.dart';
import 'package:project_brass/features/number_trivia/infrastucture/datasource/number_trivia_remote_data_source.dart';
import 'package:project_brass/features/number_trivia/infrastucture/models/number_trivia_model.dart';
import 'package:project_brass/features/number_trivia/infrastucture/repositories/number_trivia_repository_impl.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockLocalDataSource localDataSource;
  MockRemoteDataSource remoteDataSource;
  MockNetworkInfo networkInfo;

  setUp(() {
    localDataSource = MockLocalDataSource();
    remoteDataSource = MockRemoteDataSource();
    networkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final number = 1;
    final model = NumberTriviaModel(number: number, text: 'Trivia');
    final NumberTrivia trivia = model;

    test('should check if the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      repository.getConcreteNumberTrivia(number);

      verify(networkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(number))
            .thenAnswer((_) async => model);

        final response = await repository.getConcreteNumberTrivia(number);

        verify(remoteDataSource.getConcreteNumberTrivia(number));
        expect(response, equals(trivia));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(number))
            .thenAnswer((_) async => model);

        await repository.getConcreteNumberTrivia(number);

        verify(remoteDataSource.getConcreteNumberTrivia(number));
        verify(localDataSource.cacheNumberTrivia(model));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getConcreteNumberTrivia(number))
            .thenThrow(ServerException());

        expect(() async => await repository.getConcreteNumberTrivia(number),
            throwsA(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => model);

        final response = await repository.getConcreteNumberTrivia(number);

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(response, equals(trivia));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        expect(() async => await repository.getConcreteNumberTrivia(number),
            throwsA(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final model = NumberTriviaModel(number: 321, text: 'Trivia');
    final NumberTrivia trivia = model;

    test('should check if the device is online', () async {
      when(networkInfo.isConnected).thenAnswer((_) async => true);

      repository.getRandomNumberTrivia();

      verify(networkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => model);

        final response = await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        expect(response, equals(trivia));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => model);

        await repository.getRandomNumberTrivia();

        verify(remoteDataSource.getRandomNumberTrivia());
        verify(localDataSource.cacheNumberTrivia(model));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(remoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        expect(() async => await repository.getRandomNumberTrivia(),
            throwsA(ServerFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(localDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => model);

        final response = await repository.getRandomNumberTrivia();

        verifyZeroInteractions(remoteDataSource);
        verify(localDataSource.getLastNumberTrivia());
        expect(response, equals(trivia));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(localDataSource.getLastNumberTrivia()).thenThrow(CacheException());

        expect(() async => await repository.getRandomNumberTrivia(),
            throwsA(CacheFailure()));
      });
    });
  });
}
