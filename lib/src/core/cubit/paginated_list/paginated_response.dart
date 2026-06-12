import 'package:equatable/equatable.dart';

class PaginatedResponse<T> extends Equatable {
  const PaginatedResponse({required this.items, this.nextPage});

  final List<T> items;
  final int? nextPage;

  bool get hasMore => nextPage != null;

  @override
  List<Object?> get props => [items, nextPage];
}
