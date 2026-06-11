import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/markets_repository.dart';

class GetFavoriteIdsUseCase extends UseCase<Set<String>, NoParams> {
  GetFavoriteIdsUseCase(this._repository);

  final MarketsRepository _repository;

  @override
  Future<Either<Failure, Set<String>>> call(NoParams params) {
    return _repository.getFavoriteIds();
  }
}
