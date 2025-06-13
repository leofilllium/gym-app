import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';

class ValidateUuid implements UseCase<bool, ValidateUuidParams> {
  final AuthRepository repository;

  ValidateUuid(this.repository);

  @override
  Future<Either<Failure, bool>> call(ValidateUuidParams params) async {
    return await repository.validateUuid(params.uuid);
  }
}

class ValidateUuidParams extends Equatable {
  final String uuid;

  const ValidateUuidParams({required this.uuid});

  @override
  List<Object?> get props => [uuid];
}