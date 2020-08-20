import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:project_brass/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfo;

  MockDataConnectionChecker connectionChecker;

  setUp(() {
    connectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(connectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      final hasConnection = Future.value(true);

      when(connectionChecker.hasConnection).thenAnswer((_) => hasConnection);

      final result = networkInfo.isConnected;

      verify(connectionChecker.hasConnection);
      expect(result, hasConnection);
    });
  });
}
