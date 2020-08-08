import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project_brass/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:project_brass/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:project_brass/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia useCase;

  MockNumberTriviaRepository mockRepository;

  final number = 1;
  final mockNumberTrivia = NumberTrivia(number: number, text: 'Test');

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockRepository);
  });

  test('should get trivia for the number from the repository', () async {
    when(mockRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => mockNumberTrivia);

    final response = await useCase(number: number);

    expect(response, mockNumberTrivia);
    verify(mockRepository.getConcreteNumberTrivia(number));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should throw Failure if fails', () async {
    when(mockRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_) async => mockNumberTrivia);

    final response = await useCase(number: number);

    expect(response, mockNumberTrivia);
    verify(mockRepository.getConcreteNumberTrivia(number));
    verifyNoMoreInteractions(mockRepository);
  });
}
