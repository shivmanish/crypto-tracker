import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/markets_repository.dart';

class SaveFavoritesUseCase extends UseCase<void, Set<String>> {
  SaveFavoritesUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, void>> call(Set<String> ids) {
    return _repository.saveFavoriteIds(ids);
  }
}
