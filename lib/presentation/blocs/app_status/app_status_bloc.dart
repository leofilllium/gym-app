import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/usecases/auth/get_saved_language.dart';
import 'package:gym_app/domain/usecases/auth/get_saved_uuid.dart';
import 'package:gym_app/domain/usecases/auth/save_language.dart';
import 'package:gym_app/domain/usecases/auth/save_uuid.dart';
import 'package:gym_app/domain/usecases/auth/validate_uuid.dart';
import 'package:gym_app/presentation/blocs/app_status/app_status_event.dart';
import 'package:gym_app/presentation/blocs/app_status/app_status_state.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  final GetSavedUuid getSavedUuid;
  final ValidateUuid validateUuid;
  final GetSavedLanguage getSavedLanguage;
  final SaveLanguage saveLanguageUseCase;
  final SaveUuid saveUuidUseCase;

  AppStatusBloc({
    required this.getSavedUuid,
    required this.validateUuid,
    required this.getSavedLanguage,
    required this.saveLanguageUseCase,
    required this.saveUuidUseCase,
  }) : super(AppStatusLoading()) {
    on<LoadAppStatus>(_onLoadAppStatus);
    on<SaveLanguageEvent>(_onSaveLanguage);
    on<SaveUuidEvent>(_onSaveUuid);
  }

  Future<void> _onLoadAppStatus(
      LoadAppStatus event, Emitter<AppStatusState> emit) async {
    final languageResult = await getSavedLanguage(NoParams());
    String? selectedLanguage;
    languageResult.fold(
          (failure) => print('Error loading language: ${failure.message}'),
          (language) => selectedLanguage = language,
    );

    if (selectedLanguage == null) {
      emit(AppStatusLanguageUnselected());
      return;
    }

    final uuidResult = await getSavedUuid(NoParams());
    await uuidResult.fold(
          (failure) {
        emit(AppStatusUnauthenticated(selectedLanguage: selectedLanguage!));
      },
          (uuid) async {
        if (uuid != null && uuid.isNotEmpty) {
          emit(AppStatusAuthenticated(selectedLanguage: selectedLanguage!));
        } else {
          emit(AppStatusUnauthenticated(selectedLanguage: selectedLanguage!));
        }
      },
    );
  }

  Future<void> _onSaveLanguage(
      SaveLanguageEvent event, Emitter<AppStatusState> emit) async { // Updated event name
    final result = await saveLanguageUseCase(SaveLanguageParams(languageCode: event.languageCode)); // Call UseCase
    result.fold(
          (failure) => emit(AppStatusLanguageUnselected()),
          (_) => emit(AppStatusUnauthenticated(selectedLanguage: event.languageCode)),
    );
  }

  Future<void> _onSaveUuid(SaveUuidEvent event, Emitter<AppStatusState> emit) async { // Updated event name
    final result = await saveUuidUseCase(SaveUuidParams(uuid: event.uuid)); // Call UseCase
    result.fold(
          (failure) {
        final currentLanguage = (state is AppStatusAuthenticated)
            ? (state as AppStatusAuthenticated).selectedLanguage
            : (state is AppStatusUnauthenticated)
            ? (state as AppStatusUnauthenticated).selectedLanguage
            : 'en';
        emit(AppStatusUnauthenticated(selectedLanguage: currentLanguage));
      },
          (_) {
        final currentLanguage = (state is AppStatusAuthenticated)
            ? (state as AppStatusAuthenticated).selectedLanguage
            : (state is AppStatusUnauthenticated)
            ? (state as AppStatusUnauthenticated).selectedLanguage
            : 'en';
        emit(AppStatusAuthenticated(selectedLanguage: currentLanguage));
      },
    );
  }
}