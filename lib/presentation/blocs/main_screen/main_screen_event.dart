import 'package:equatable/equatable.dart';

abstract class MainScreenEvent extends Equatable {
  const MainScreenEvent();

  @override
  List<Object?> get props => [];
}

class LoadMainScreenCategories extends MainScreenEvent {
  final String languageCode;

  const LoadMainScreenCategories({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class FilterCategories extends MainScreenEvent {
  final String query;

  const FilterCategories({required this.query});

  @override
  List<Object?> get props => [query];
}

class ResetLanguage extends MainScreenEvent {}