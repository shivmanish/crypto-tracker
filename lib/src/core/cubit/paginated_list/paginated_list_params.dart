import 'package:equatable/equatable.dart';

abstract class PaginatedListParams extends Equatable {
  const PaginatedListParams({required this.page, required this.pageSize});

  final int page;
  final int pageSize;

  @override
  List<Object?> get props => [page, pageSize];
}
