import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/domain/usecases/category/get_categories.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_event.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_state.dart';

class CategorySliderBloc extends Bloc<CategorySliderEvent, CategorySliderState> {
  final GetCategories getCategories;

  CategorySliderBloc({required this.getCategories}) : super(CategorySliderInitial()) {
    on<LoadCategorySlider>(_onLoadCategorySlider);
  }

  Future<void> _onLoadCategorySlider(
      LoadCategorySlider event, Emitter<CategorySliderState> emit) async {
    emit(CategorySliderLoading());
    final result = await getCategories(GetCategoriesParams(languageCode: event.languageCode));
    result.fold(
          (failure) {
        emit(CategorySliderError(message: failure.message));
      },
          (categories) {
        emit(CategorySliderLoaded(categories: categories));
      },
    );
  }
}