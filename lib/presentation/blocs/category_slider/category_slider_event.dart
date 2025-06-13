import 'package:equatable/equatable.dart';

abstract class CategorySliderEvent extends Equatable {
  const CategorySliderEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategorySlider extends CategorySliderEvent {
  final String languageCode;

  const LoadCategorySlider({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}