import '../../../../core/use_cases/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository _repository;

  GetRandomNumberTrivia(this._repository);

  Future<NumberTrivia> call(NoParams params) async {
    try {
      return await _repository.getRandomNumberTrivia();
    } catch (e) {
      throw Failure();
    }
  }
}
