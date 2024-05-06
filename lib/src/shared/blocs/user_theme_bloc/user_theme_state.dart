part of 'user_theme_bloc.dart';

sealed class UserThemeState {}

final class UserThemeLoadingState extends UserThemeState {}

final class UserThemeLoadedState extends UserThemeState {
  final ThemeMode themeMode;

  UserThemeLoadedState({
    required this.themeMode,
  });
}

final class UserThemeErrorState extends UserThemeState {
  final String errorMessage;

  UserThemeErrorState({
    required this.errorMessage,
  });
}
