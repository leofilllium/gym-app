import 'package:dartz/dartz.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';

class GetSavedUuid implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetSavedUuid(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) async {
    return await repository.getSavedUuid();
  }
}