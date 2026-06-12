import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';

class FavoritesState extends Equatable {
  const FavoritesState({this.ids = const {}, this.error});

  final Set<String> ids;
  final Failure? error;

  bool isFavorite(String coinId) => ids.contains(coinId);

  FavoritesState copyWith({
    Set<String>? ids,
    Failure? error,
    bool clearError = false,
  }) {
    return FavoritesState(
      ids: ids ?? this.ids,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [ids, error];
}
