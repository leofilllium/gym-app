import 'package:dartz/dartz.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/data/datasources/local/auth_local_datasource.dart';
import 'package:gym_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String?>> getSavedUuid() async {
    try {
      final uuid = await localDataSource.getSavedUuid();
      return Right(uuid);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveUuid(String uuid) async {
    try {
      await localDataSource.saveUuid(uuid);
      return const Right(null);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> validateUuid(String uuid) async {
    try {
      final isValid = await remoteDataSource.validateUuid(uuid);
      return Right(isValid);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkFailure catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String?>> getSavedLanguage() async {
    try {
      final language = await localDataSource.getSavedLanguage();
      return Right(language);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveLanguage(String languageCode) async {
    try {
      await localDataSource.saveLanguage(languageCode);
      return const Right(null);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeLanguage() async {
    try {
      await localDataSource.removeLanguage();
      return const Right(null);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}