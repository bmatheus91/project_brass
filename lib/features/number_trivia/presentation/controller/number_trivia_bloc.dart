import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';

import '../../../../core/use_cases/use_case.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/use_cases/get_concrete_number_trivia.dart';
import '../../domain/use_cases/get_random_number_trivia.dart';
import 'number_trivia_state.dart';
import 'number_trivia_event.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(NumberTriviaInitial());

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    try {
      if (event is GetTriviaForConcreteNumber) {
        final input = inputConverter.stringToUnsignedInteger(event.number);

        yield NumberTriviaLoading();

        final response = await getConcreteNumberTrivia(Params(number: input));

        yield NumberTriviaLoaded(trivia: response);
      } else if (event is GetTriviaForRandomNumber) {
        yield NumberTriviaLoading();

        final response = await getRandomNumberTrivia(NoParams());

        yield NumberTriviaLoaded(trivia: response);
      }
    } on Failure catch (e) {
      yield NumberTriviaError(message: _mapFailureToMessage(e));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case InvalidInputFailure:
        return INVALID_INPUT_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
