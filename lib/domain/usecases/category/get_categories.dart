import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_app/core/errors/failures.dart';
import 'package:gym_app/core/usecases/usecase.dart';
import 'package:gym_app/domain/entities/category_entity.dart';
import 'package:gym_app/domain/repositories/category_repository.dart';

class GetCategories implements UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategories(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(GetCategoriesParams params) async {
    return await repository.getCategories(params.languageCode);
  }
}

class GetCategoriesParams extends Equatable {
  final String languageCode;

  const GetCategoriesParams({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}