part of flutter_nav2_oop;

extension ColorEx on Color {

  ThemeData toTheme({
    Brightness brightness = Brightness.light,
    bool useMaterial3 = true,
    TextTheme? textTheme
  }) => ThemeData.from(
      useMaterial3: useMaterial3,
      colorScheme: ColorScheme.fromSeed(seedColor: this, brightness: brightness),
      textTheme: textTheme
  );

  ThemeData toDarkTheme({
    bool useMaterial3 = true,
    TextTheme? textTheme
  }) =>
      toTheme(brightness: Brightness.dark, useMaterial3: useMaterial3, textTheme: textTheme);
}