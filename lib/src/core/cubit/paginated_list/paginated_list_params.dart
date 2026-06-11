import 'package:equatable/equatable.dart';

/// Universal pagination params. Concrete params extend this (adding filters,
/// search, etc.) and implement [APIRouter] so the endpoint travels with them.
abstract class PaginatedListParams extends Equatable {
  const PaginatedListParams({required this.page, required this.pageSize});

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}
