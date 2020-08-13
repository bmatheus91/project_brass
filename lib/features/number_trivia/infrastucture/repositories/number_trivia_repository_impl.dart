import '../../../../core/platform/network_info.dart';
import '../datasource/number_trivia_local_data_source.dart';
import '../datasource/number_trivia_remote_data_source.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {this.localDataSource, this.remoteDataSource, this.networkInfo});

  @override
  Future<NumberTrivia> getConcreteNumberTrivia(int number) async {
    try {
      networkInfo.isConnected;

      final remoteTrivia =
          await remoteDataSource.getConcreteNumberTrivia(number);

      localDataSource.cacheNumberTrivia(remoteTrivia);

      return remoteTrivia;
    } on ServerException {
      throw ServerFailure();
    }
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
