import 'package:dartz/dartz.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/data/datasources/remote/category_remote_datasource.dart';
import 'package:gym_app/domain/entities/category_entity.dart';
import 'package:gym_app/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
      String languageCode) async {
    try {
      final categories = await remoteDataSource.fetchCategories(languageCode);
      return Right(categories);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkFailure catch (e) {
      return Left(NetworkFailure(message: e.message));
    }
  }
}