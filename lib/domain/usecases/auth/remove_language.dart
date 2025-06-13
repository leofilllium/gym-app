import 'package:dartz/dartz.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';

class RemoveLanguage implements UseCase<void, NoParams> {
  final AuthRepository repository;

  RemoveLanguage(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.removeLanguage();
  }
}