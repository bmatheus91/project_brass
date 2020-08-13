import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:project_brass/core/use_cases/use_case.dart';
import 'package:project_brass/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:project_brass/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:project_brass/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia useCase;

  MockNumberTriviaRepository mockRepository;

  final number = 1;
  final mockNumberTrivia = NumberTrivia(number: number, text: 'Test');

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(mockRepository);
  });

  test('should get trivia from the repository', () async {
    when(mockRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => mockNumberTrivia);

    final response = await useCase(NoParams());

    expect(response, mockNumberTrivia);
    verify(mockRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockRepository);
  });
}
