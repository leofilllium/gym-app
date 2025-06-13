import 'package:equatable/equatable.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';

class CategoryEntity extends Equatable {
  final String name;
  final List<SubcategoryEntity> subcategories;

  const CategoryEntity({required this.name, required this.subcategories});

  @override
  List<Object?> get props => [name, subcategories];
}