import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_brass/core/error/failures.dart';
import 'package:project_brass/core/util/input_converter.dart';

void main() {
  InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        final str = '123';

        final result = converter.stringToUnsignedInteger(str);

        expect(result, 123);
      },
    );
  });

  test(
    'should return a failure when the string is not an integer',
    () async {
      final str = 'abc';

      final call = converter.stringToUnsignedInteger;

      expect(() => call(str), throwsA(TypeMatcher<InvalidInputFailure>()));
    },
  );

  test(
    'should return a failure when the string is a negative integer',
    () async {
      final str = '-123';

      final call = converter.stringToUnsignedInteger;

      expect(() => call(str), throwsA(TypeMatcher<InvalidInputFailure>()));
    },
  );
}
