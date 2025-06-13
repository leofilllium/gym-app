import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/domain/entities/category_entity.dart';
import 'package:gym_app/presentation/pages/subcategory_screen.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final String language;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final label = (() {
      switch (language) {
        case 'uz':
          return 'video';
        case 'ru':
          return 'видео';
        default:
          return 'videos';
      }
    })();
    IconData iconData;

    switch (category.name.toLowerCase()) {
      case 'bomb sets':
      case 'бомбовые сеты':
      case "bomba to'plamlari":
        iconData = Icons.whatshot;
        break;
      case 'hernia':
      case 'грыжа':
      case "grija":
        iconData = Icons.health_and_safety;
        break;
      case 'for the full':
      case 'для полных':
      case "to'liqlar uchun":
        iconData = Icons.accessibility_new;
        break;
      case 'home workouts':
      case 'домашние тренировки':
      case "uy mashg'ulotlari":
        iconData = Icons.home;
        break;
      case 'mesomorph':
      case 'мезаморф':
      case 'mezamorf':
        iconData = Icons.fitness_center;
        break;
      case 'press':
      case 'пресс':
      case 'press':
        iconData = Icons.sports_gymnastics;
        break;
      case 'proper nutrition diet':
      case 'рацион правильного питания':
      case "to'g'ri ovqatlanish dietasi":
        iconData = Icons.restaurant_menu;
        break;
      case 'sports supplements':
      case 'спортивные добавки':
      case "sport qo'shimchalar":
        iconData = Icons.local_pharmacy;
        break;
      case 'ectomorph':
      case 'эктоморф':
      case 'ektomorf':
        iconData = Icons.accessibility;
        break;
      case 'endomorph':
      case 'эндоморф':
      case 'endomorf':
        iconData = Icons.directions_run;
        break;
      default:
        iconData = Icons.sports;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => SubcategoryScreen(
                  category: category,
                  language: language,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, size: 28, color: const Color(0xFF0A84FF)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_countTotalItems(category)} $label',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.chevron_right,
                    size: 16, color: Color(0xFF0A84FF)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _countTotalItems(CategoryEntity category) {
    var count = 0;
    for (var sub in category.subcategories) {
      if (sub.video != null) count++;
      if (sub.subcategories != null) {
        for (var subSub in sub.subcategories!) {
          if (subSub.video != null) count++;
          if (subSub.subcategories != null) {
            count += subSub.subcategories!.length;
          }
        }
      }
    }
    return count;
  }
}