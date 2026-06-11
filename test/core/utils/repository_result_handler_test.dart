import 'package:crypto_tracker/src/core/error/exceptions.dart';
import 'package:crypto_tracker/src/core/error/failures.dart';
import 'package:crypto_tracker/src/core/utils/repository_result_handler.dart';
import 'package:flutter_test/flutter_test.dart';

class _Handler with RepositoryResultHandler {}

void main() {
  final handler = _Handler();

  Future<Failure?> resultFailure(Object error) async {
    final either = await handler.result<int>(() async => throw error);
    return either.fold((f) => f, (_) => null);
  }

  Future<Failure?> localFailure(Object error) async {
    final either = await handler.localResult<int>(() async => throw error);
    return either.fold((f) => f, (_) => null);
  }

  group('result()', () {
    test('wraps a value in Right', () async {
      final either = await handler.result<int>(() async => 42);
      expect(either.getOrElse(() => -1), 42);
    });

    test('maps each exception type to its Failure', () async {
      expect(await resultFailure(NetworkException()), isA<NetworkFailure>());
      expect(await resultFailure(RateLimitException()), isA<RateLimitFailure>());
      expect(await resultFailure(NotFoundException('x')), isA<NotFoundFailure>());
      expect(await resultFailure(CacheException()), isA<CacheFailure>());
      expect(await resultFailure(ServerException('x')), isA<ServerFailure>());
      expect(await resultFailure(ArgumentError('x')), isA<UnknownFailure>());
    });
  });

  group('localResult()', () {
    test('maps cache/not-found and treats anything else as CacheFailure',
        () async {
      expect(await localFailure(CacheException()), isA<CacheFailure>());
      expect(await localFailure(NotFoundException('x')), isA<NotFoundFailure>());
      expect(await localFailure(StateError('x')), isA<CacheFailure>());
    });
  });
}
