import '../../../../core/platform/network_info.dart';
import '../datasource/number_trivia_local_data_source.dart';
import '../datasource/number_trivia_remote_data_source.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {this.localDataSource, this.remoteDataSource, this.networkInfo});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async =>
      await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async =>
      await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());

  Future<NumberTrivia> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    try {
      if (await networkInfo.isConnected) {
        final remoteTrivia = await getConcreteOrRandom();

        localDataSource.cacheNumberTrivia(remoteTrivia);

        return remoteTrivia;
      }

      final localTrivia = await localDataSource.getLastNumberTrivia();

      return localTrivia;
    } on ServerException {
      throw ServerFailure();
    } on CacheException {
      throw CacheFailure();
    }
  }
}
