// lib/presentation/blocs/auth/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/domain/usecases/auth/save_uuid.dart';
import 'package:gym_app/domain/usecases/auth/validate_uuid.dart';
import 'package:gym_app/presentation/blocs/auth/auth_event.dart';
import 'package:gym_app/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ValidateUuid validateUuid;
  final SaveUuid saveUuid;
  final AppLocalization appLocalization;

  AuthBloc({
    required this.validateUuid,
    required this.saveUuid,
    required this.appLocalization,
  }) : super(AuthInitial()) {
    on<AuthSubmitEvent>(_onAuthSubmit);
  }

  Future<void> _onAuthSubmit(
      AuthSubmitEvent event, Emitter<AuthState> emit) async {
    if (event.uuid.isEmpty) {
      emit(AuthFailure(message: appLocalization.getLocalizedText('authEnterKey', event.languageCode)));
      return;
    }

    emit(AuthLoading());
    final result = await validateUuid(ValidateUuidParams(uuid: event.uuid));

    await result.fold(
          (failure) async {
        String errorMessage;
        if (failure is NetworkFailure) {
          errorMessage = appLocalization.getLocalizedText('authValidationError', event.languageCode);
        } else if (failure is ServerFailure) {
          errorMessage = appLocalization.getLocalizedText('authValidationError', event.languageCode);
        } else {
          errorMessage = '${appLocalization.getLocalizedText('videoErrorPrefix', event.languageCode)}${failure.message}';
        }
        emit(AuthFailure(message: errorMessage));
      },
          (isValid) async {
        if (isValid) {
          await saveUuid(SaveUuidParams(uuid: event.uuid));
          emit(AuthSuccess());
        } else {
          emit(AuthFailure(message: appLocalization.getLocalizedText('authIncorrectKey', event.languageCode)));
        }
      },
    );
  }
}