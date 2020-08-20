import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_brass/core/error/failures.dart';
import 'package:project_brass/core/util/input_converter.dart';
import 'package:project_brass/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:project_brass/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:project_brass/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:project_brass/features/number_trivia/presentation/controller/bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  tearDown(() {
    bloc.close();
  });

  test('initialState should be NumberTriviaInitial', () {
    expect(bloc.state, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    final number = '1';

    final parsedNumber = int.parse(number);

    final trivia = NumberTrivia(number: 1, text: 'test trivia');

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(parsedNumber);

        bloc.add(GetTriviaForConcreteNumber(number));

        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

        verify(mockInputConverter.stringToUnsignedInteger(number));
      },
    );

    test(
      'should emit [NumberTriviaError] when the input is invalid',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenThrow(InvalidInputFailure());

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(number));
      },
    );
  });
}
