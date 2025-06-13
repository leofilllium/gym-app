import 'package:equatable/equatable.dart';

class SubcategoryEntity extends Equatable {
  final String name;
  final String? video;
  final List<SubcategoryEntity>? subcategories;

  const SubcategoryEntity({
    required this.name,
    this.video,
    this.subcategories,
  });

  @override
  List<Object?> get props => [name, video, subcategories];
}