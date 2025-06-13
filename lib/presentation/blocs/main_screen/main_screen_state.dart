import 'package:equatable/equatable.dart';
import 'package:gym_app/domain/entities/category_entity.dart';

abstract class MainScreenState extends Equatable {
  const MainScreenState();

  @override
  List<Object?> get props => [];
}

class MainScreenLoading extends MainScreenState {}

class MainScreenLoaded extends MainScreenState {
  final List<CategoryEntity> categories;
  final String languageCode;

  const MainScreenLoaded({required this.categories, required this.languageCode});

  @override
  List<Object?> get props => [categories, languageCode];
}

class MainScreenError extends MainScreenState {
  final String message;

  const MainScreenError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MainScreenEmpty extends MainScreenState {
  final String message;

  const MainScreenEmpty({required this.message});

  @override
  List<Object?> get props => [message];
}