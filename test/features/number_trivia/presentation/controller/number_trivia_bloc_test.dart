import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_brass/core/error/failures.dart';
import 'package:project_brass/core/use_cases/use_case.dart';
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

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(parsedNumber);

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      () async {
        setUpMockInputConverterSuccess();

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

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any)).thenThrow(ServerFailure());

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(number));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any)).thenThrow(CacheFailure());

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(number));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        setUpMockInputConverterSuccess();

        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => trivia);

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: trivia),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForConcreteNumber(number));
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async => trivia);

        bloc.add(GetTriviaForConcreteNumber(number));

        await untilCalled(mockGetConcreteNumberTrivia(any));

        verify(mockGetConcreteNumberTrivia(Params(number: parsedNumber)));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final trivia = NumberTrivia(number: 1, text: 'Test');

    test(
      'should get data from the random use case',
      () async {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => trivia);

        bloc.add(GetTriviaForRandomNumber());

        await untilCalled(mockGetRandomNumberTrivia(any));

        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () async {
        when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async => trivia);

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaLoaded(trivia: trivia),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] when getting data fails',
      () async {
        when(mockGetRandomNumberTrivia(any)).thenThrow(ServerFailure());

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForRandomNumber());
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () async {
        when(mockGetRandomNumberTrivia(any)).thenThrow(CacheFailure());

        final expected = [
          // NumberTriviaInitial(),
          NumberTriviaLoading(),
          NumberTriviaError(message: CACHE_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        bloc.add(GetTriviaForRandomNumber());
      },
    );
  });
}
