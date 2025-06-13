// lib/presentation/pages/subcategory_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/domain/entities/category_entity.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';
import 'package:gym_app/presentation/pages/nested_subcategory_screen.dart';
import 'package:gym_app/presentation/pages/video_player_screen.dart';

class SubcategoryScreen extends StatelessWidget {
  final CategoryEntity category;
  final String language;

  const SubcategoryScreen({
    Key? key,
    required this.category,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name.toUpperCase()),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: category.subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = category.subcategories[index];
          return _buildSubcategoryItem(context, subcategory);
        },
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, SubcategoryEntity subcategory) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            if (subcategory.subcategories != null &&
                subcategory.subcategories!.isNotEmpty) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => NestedSubcategoryScreen(
                    title: subcategory.name,
                    subcategories: subcategory.subcategories!,
                    language: language,
                  ),
                ),
              );
            } else if (subcategory.video != null) {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => VideoPlayerScreen(
                    title: subcategory.name,
                    videoUrl: subcategory.video!,
                    language: language,
                  ),
                ),
              );
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    subcategory.subcategories != null &&
                        subcategory.subcategories!.isNotEmpty
                        ? CupertinoIcons.folder_fill
                        : CupertinoIcons.play_circle_fill,
                    color: const Color(0xFF0A84FF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subcategory.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      if (subcategory.subcategories != null &&
                          subcategory.subcategories!.isNotEmpty)
                        Text(
                          '${subcategory.subcategories!.length} ${_getItemsText(language, subcategory.subcategories!.length)}',
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

  String _getItemsText(String language, int count) {
    switch (language) {
      case 'ru':
        return count == 1 ? 'элемент' : (count < 5 ? 'элемента' : 'элементов');
      case 'uz':
        return 'element' + (count == 1 ? '' : 'lar');
      default:
        return count == 1 ? 'item' : 'items';
    }
  }
}