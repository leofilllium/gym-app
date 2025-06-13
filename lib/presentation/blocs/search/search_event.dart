import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllVideos extends SearchEvent {
  final String languageCode;

  const LoadAllVideos({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}

class PerformSearch extends SearchEvent {
  final String query;

  const PerformSearch({required this.query});

  @override
  List<Object?> get props => [query];
}