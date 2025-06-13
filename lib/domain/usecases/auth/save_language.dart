import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';

class SaveLanguage implements UseCase<void, SaveLanguageParams> {
  final AuthRepository repository;

  SaveLanguage(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveLanguageParams params) async {
    return await repository.saveLanguage(params.languageCode);
  }
}

class SaveLanguageParams extends Equatable {
  final String languageCode;

  const SaveLanguageParams({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}