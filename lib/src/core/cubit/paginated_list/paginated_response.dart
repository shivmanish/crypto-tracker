import 'package:equatable/equatable.dart';

/// One page of results plus the cursor to the next page.
///
/// [nextPage] is null when there are no more pages. For APIs that return
/// pagination metadata, set it from the response; for bare-list APIs (e.g.
/// CoinGecko markets) the repository derives it from page fullness.
class PaginatedResponse<T> extends Equatable {
  const PaginatedResponse({required this.items, this.nextPage});

  final List<T> items;
  final int? nextPage;

  bool get hasMore => nextPage != null;

  @override
  List<Object?> get props => [items, nextPage];
}
