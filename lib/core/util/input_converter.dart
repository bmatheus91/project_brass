import '../error/failures.dart';

class InputConverter {
  int stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);

      if (integer < 0) throw FormatException();

      return integer;
    } on FormatException {
      throw InvalidInputFailure();
    }
  }
}
