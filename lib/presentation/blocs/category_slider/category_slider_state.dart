import 'package:equatable/equatable.dart';
import 'package:gym_app/domain/entities/category_entity.dart';

abstract class CategorySliderState extends Equatable {
  const CategorySliderState();

  @override
  List<Object?> get props => [];
}

class CategorySliderInitial extends CategorySliderState {}

class CategorySliderLoading extends CategorySliderState {}

class CategorySliderLoaded extends CategorySliderState {
  final List<CategoryEntity> categories;

  const CategorySliderLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategorySliderError extends CategorySliderState {
  final String message;

  const CategorySliderError({required this.message});

  @override
  List<Object?> get props => [message];
}