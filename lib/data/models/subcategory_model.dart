import 'package:gym_app/domain/entities/subcategory_entity.dart';

class SubcategoryModel extends SubcategoryEntity {
  const SubcategoryModel({
    required super.name,
    super.video,
    super.subcategories,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      name: json['name'] ?? 'Unknown',
      video: json['video'],
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List<dynamic>)
          .map((subJson) => SubcategoryModel.fromJson(subJson))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'video': video,
      'subcategories': subcategories?.map((e) => (e as SubcategoryModel).toJson()).toList(),
    };
  }
}