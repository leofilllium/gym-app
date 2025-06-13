import 'package:dartz/dartz.dart';
import 'package:gym_app/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> validateUuid(String uuid);
  Future<Either<Failure, void>> saveUuid(String uuid);
  Future<Either<Failure, String?>> getSavedUuid();
  Future<Either<Failure, void>> saveLanguage(String languageCode);
  Future<Either<Failure, String?>> getSavedLanguage();
  Future<Either<Failure, void>> removeLanguage();
}