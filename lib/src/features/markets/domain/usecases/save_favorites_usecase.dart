import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/markets_repository.dart';

/// Persists the full favorite-id set (the cubit owns the in-memory truth).
class SaveFavoritesUseCase extends UseCase<void, Set<String>> {
  SaveFavoritesUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, void>> call(Set<String> ids) {
    return _repository.saveFavoriteIds(ids);
  }
}
