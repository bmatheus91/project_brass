import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project_brass/core/platform/network_info.dart';
import 'package:project_brass/features/number_trivia/infrastucture/datasource/number_trivia_local_data_source.dart';
import 'package:project_brass/features/number_trivia/infrastucture/datasource/number_trivia_remote_data_source.dart';
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
}
