// lib/presentation/pages/nested_subcategory_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';
import 'package:gym_app/presentation/pages/video_player_screen.dart';

class NestedSubcategoryScreen extends StatelessWidget {
  final String title;
  final List<SubcategoryEntity> subcategories;
  final String language;

  const NestedSubcategoryScreen({
    Key? key,
    required this.title,
    required this.subcategories,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.toUpperCase()),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return _buildNestedSubcategoryItem(context, subcategory);
        },
      ),
    );
  }

  Widget _buildNestedSubcategoryItem(
      BuildContext context, SubcategoryEntity subcategory) {
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
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: subcategory.video != null
                        ? const Color(0xFF0A84FF)
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    subcategory.video != null
                        ? CupertinoIcons.play_fill
                        : CupertinoIcons.folder_fill,
                    color: subcategory.video != null
                        ? Colors.white
                        : const Color(0xFF0A84FF),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    subcategory.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
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
}