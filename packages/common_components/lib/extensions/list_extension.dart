extension ListExtensions<T> on List<T>? {
  bool get isNotNullAndEmpty {
    final value = this;
    return value != null && value.isNotEmpty;
  }

  bool get isNullOrEmpty {
    final value = this;
    return value == null || value.isEmpty;
  }
}