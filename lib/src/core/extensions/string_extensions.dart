extension StringX on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => trim().isNotEmpty;

  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String ellipsize(int max) =>
      length <= max ? this : '${substring(0, max)}…';
}
