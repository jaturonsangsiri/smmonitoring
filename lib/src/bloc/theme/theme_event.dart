part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SetTheme extends ThemeEvent {}

class InitTheme extends ThemeEvent {
  final bool theme;
  const InitTheme(this.theme);

  @override
  List<Object> get props => [theme];
}
