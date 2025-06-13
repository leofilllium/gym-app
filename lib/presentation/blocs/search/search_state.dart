import 'package:equatable/equatable.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SubcategoryEntity> results;
  final String languageCode;

  const SearchLoaded({required this.results, required this.languageCode});

  @override
  List<Object?> get props => [results, languageCode];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object?> get props => [message];
}