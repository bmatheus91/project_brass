import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/number_trivia.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia trivia;

  NumberTriviaLoaded({@required this.trivia});

  @override
  List<Object> get props => [trivia];
}

class NumberTriviaError extends NumberTriviaState {
  final String message;

  NumberTriviaError({@required this.message});

  @override
  List<Object> get props => [message];
}
