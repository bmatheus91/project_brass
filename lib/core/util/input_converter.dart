import '../error/failures.dart';

class InputConverter {
  int stringToUnsignedInteger(String str) {
    try {
      if (str == null || str.isEmpty) throw FormatException();

      final integer = int.parse(str);

      if (integer < 0) throw FormatException();

      return integer;
    } on FormatException {
      throw InvalidInputFailure();
    }
  }
}
