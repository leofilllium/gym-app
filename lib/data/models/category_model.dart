import 'package:gym_app/data/models/subcategory_model.dart';
import 'package:gym_app/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.name,
    required super.subcategories,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? 'Unknown',
      subcategories: (json['subcategories'] as List<dynamic>?)
          ?.map((subJson) => SubcategoryModel.fromJson(subJson))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subcategories': subcategories.map((e) => (e as SubcategoryModel).toJson()).toList(),
    };
  }
}