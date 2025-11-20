import 'package:flutter_riverpod/flutter_riverpod.dart';

// Minimal extensions to reduce boilerplate
extension AsyncValueEx<T> on AsyncValue<T> {
  T? get valueOrNull => hasValue ? value : null;
}
