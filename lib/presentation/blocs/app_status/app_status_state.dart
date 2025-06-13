import 'package:equatable/equatable.dart';

abstract class AppStatusState extends Equatable {
  const AppStatusState();

  @override
  List<Object?> get props => [];
}

class AppStatusLoading extends AppStatusState {}

class AppStatusLanguageUnselected extends AppStatusState {}

class AppStatusUnauthenticated extends AppStatusState {
  final String selectedLanguage;

  const AppStatusUnauthenticated({required this.selectedLanguage});

  @override
  List<Object?> get props => [selectedLanguage];
}

class AppStatusAuthenticated extends AppStatusState {
  final String selectedLanguage;

  const AppStatusAuthenticated({required this.selectedLanguage});

  @override
  List<Object?> get props => [selectedLanguage];
}