import 'dart:ffi';

extension IntExtensions on Int? {
  bool get isNotNull {
    final value = this;
    return value != null;
  }
}
