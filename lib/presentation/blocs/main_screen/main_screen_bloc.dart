import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/entities/category_entity.dart';
import 'package:gym_app/domain/usecases/auth/remove_language.dart';
import 'package:gym_app/domain/usecases/category/get_categories.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_event.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  final GetCategories getCategories;
  final RemoveLanguage removeLanguage;
  final AppLocalization appLocalization;

  MainScreenBloc({
    required this.getCategories,
    required this.removeLanguage,
    required this.appLocalization,
  }) : super(MainScreenLoading()) {
    on<LoadMainScreenCategories>(_onLoadMainScreenCategories);
    on<FilterCategories>(_onFilterCategories);
    on<ResetLanguage>(_onResetLanguage);
  }

  List<CategoryEntity> _allCategories = [];

  Future<void> _onLoadMainScreenCategories(
      LoadMainScreenCategories event, Emitter<MainScreenState> emit) async {
    emit(MainScreenLoading());
    final result = await getCategories(GetCategoriesParams(languageCode: event.languageCode));
    result.fold(
          (failure) {
        emit(MainScreenError(
            message: appLocalization.getLocalizedText('mainFailedToLoadWorkouts', event.languageCode)));
      },
          (categories) {
        _allCategories = categories;
        if (categories.isEmpty) {
          emit(MainScreenEmpty(
              message: appLocalization.getLocalizedText('mainNoWorkoutsFound', event.languageCode)));
        } else {
          emit(MainScreenLoaded(categories: categories, languageCode: event.languageCode));
        }
      },
    );
  }

  void _onFilterCategories(FilterCategories event, Emitter<MainScreenState> emit) {
    if (event.query.isEmpty) {
      emit(MainScreenLoaded(categories: _allCategories, languageCode: (state as MainScreenLoaded).languageCode));
    } else {
      final filtered = _allCategories
          .where((category) =>
          category.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(MainScreenLoaded(categories: filtered, languageCode: (state as MainScreenLoaded).languageCode));
    }
  }

  Future<void> _onResetLanguage(ResetLanguage event, Emitter<MainScreenState> emit) async {
    await removeLanguage(NoParams());
    // This will trigger MyApp to rebuild and go to language selection
  }
}