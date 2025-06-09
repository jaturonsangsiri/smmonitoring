part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final bool themeApp;

  const ThemeState({
    this.themeApp = false,
  });

  ThemeState copyWith({
    bool? themeApp,
  }) {
    return ThemeState(
      themeApp: themeApp ?? this.themeApp,
    );
  }
  
  @override
  List<Object> get props => [themeApp];
}
