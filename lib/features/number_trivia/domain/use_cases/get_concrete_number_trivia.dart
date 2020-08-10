import 'package:equatable/equatable.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository _repository;

  GetConcreteNumberTrivia(this._repository);

  Future<NumberTrivia> call(Params params) async {
    try {
      return await _repository.getConcreteNumberTrivia(params.number);
    } catch (e) {
      throw Failure();
    }
  }
}

class Params extends Equatable {
  final int number;

  Params({this.number});

  @override
  List<Object> get props => [number];
}
