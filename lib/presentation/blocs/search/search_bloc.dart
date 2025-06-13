import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/domain/entities/category_entity.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';
import 'package:gym_app/domain/usecases/category/get_categories.dart';
import 'package:gym_app/presentation/blocs/search/search_event.dart';
import 'package:gym_app/presentation/blocs/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetCategories getCategories;

  SearchBloc({required this.getCategories}) : super(SearchInitial()) {
    on<LoadAllVideos>(_onLoadAllVideos);
    on<PerformSearch>(_onPerformSearch);
  }

  List<SubcategoryEntity> _allVideos = [];

  Future<void> _onLoadAllVideos(
      LoadAllVideos event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    final result = await getCategories(GetCategoriesParams(languageCode: event.languageCode));
    result.fold(
          (failure) {
        emit(SearchError(message: failure.message));
      },
          (categories) {
        final vids = <SubcategoryEntity>[];
        void collect(List<SubcategoryEntity> subs) {
          for (var s in subs) {
            if (s.video != null) vids.add(s);
            if (s.subcategories != null) collect(s.subcategories!);
          }
        }
        collect(categories.expand((c) => c.subcategories).toList());
        _allVideos = vids;
        emit(SearchLoaded(results: vids, languageCode: event.languageCode));
      },
    );
  }

  void _onPerformSearch(PerformSearch event, Emitter<SearchState> emit) {
    final filtered = _allVideos
        .where((v) => v.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(SearchLoaded(results: filtered, languageCode: (state as SearchLoaded).languageCode));
  }
}
