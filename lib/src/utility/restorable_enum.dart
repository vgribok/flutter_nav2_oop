part of flutter_nav2_oop;

/// Implements ephemeral state restoration for nullable enums
class RestorableEnumN<T> extends RestorableString {
  final Iterable<T> enumValues;

  RestorableEnumN(this.enumValues, {T? initialValue})
    : super(initialValue?.toString() ?? "");

  set enumValue(T? value) => super.value = (value?.toString() ?? "");
  T? get enumValue => enumValues.firstSafe(
          (enumVal) => enumVal.toString() == super.value
  );
}

/// Implements ephemeral state restoration for non-nullable enums
class RestorableEnum<T> extends RestorableEnumN {
  final T defaultValue;

  RestorableEnum(Iterable<T> enumValues, {required this.defaultValue})
      : super(enumValues, initialValue: defaultValue);

  @override
  set enumValue(dynamic value) => super.enumValue = value;

  @override
  T get enumValue => super.enumValue ?? defaultValue;
}