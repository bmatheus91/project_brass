import '../../../../core/error/errors.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository _repository;

  GetConcreteNumberTrivia(this._repository);

  Future<NumberTrivia> call({int number}) async {
    try {
      return await _repository.getConcreteNumberTrivia(number);
    } catch (e) {
      throw Failure();
    }
  }
}
