import 'package:flutter_test/flutter_test.dart';
import 'package:fitcoin/core/error/failures.dart';

void main() {
  group('Failures', () {
    test('should have correct props for ValidationFailure', () {
      const failure = ValidationFailure(message: 'Invalid email');
      expect(failure.message, 'Invalid email');
      expect(failure.props, ['Invalid email', null]);
    });

    test('should have correct props for NetworkFailure', () {
      const failure = NetworkFailure(message: 'No internet');
      expect(failure.message, 'No internet');
      expect(failure.props, ['No internet', null]);
    });

    test('should have correct props for TokenExpiredFailure', () {
      const failure = TokenExpiredFailure();
      expect(failure.message, 'Session expired. Please login again.');
      expect(failure.statusCode, 401);
    });

    test('should have correct props for ServerFailure', () {
      const failure = ServerFailure(
        message: 'Server error',
        statusCode: 500,
      );
      expect(failure.message, 'Server error');
      expect(failure.statusCode, 500);
      expect(failure.props, ['Server error', 500]);
    });
  });
}