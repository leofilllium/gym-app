import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';

class SaveUuid implements UseCase<void, SaveUuidParams> {
  final AuthRepository repository;

  SaveUuid(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUuidParams params) async {
    return await repository.saveUuid(params.uuid);
  }
}

class SaveUuidParams extends Equatable {
  final String uuid;

  const SaveUuidParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}