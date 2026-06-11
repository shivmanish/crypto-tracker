import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

/// Wraps repository bodies and maps typed exceptions to [Failure]s.
/// [result] for remote calls, [localResult] for cache/db reads.
mixin RepositoryResultHandler {
  Future<Either<Failure, T>> result<T>(Future<T> Function() callback) async {
    try {
      return Right(await callback());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on RateLimitException catch (e) {
      return Left(RateLimitFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, T>> localResult<T>(
    Future<T> Function() callback,
  ) async {
    try {
      return Right(await callback());
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
