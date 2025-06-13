import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_bloc.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_event.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_state.dart';
import 'package:gym_app/presentation/pages/nested_subcategory_screen.dart';
import 'package:gym_app/presentation/pages/video_player_screen.dart';
import 'package:gym_app/service_locator.dart';

class CategorySliderScreen extends StatefulWidget {
  final String language;

  const CategorySliderScreen({Key? key, required this.language}) : super(key: key);

  @override
  State<CategorySliderScreen> createState() => _CategorySliderScreenState();
}

class _CategorySliderScreenState extends State<CategorySliderScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategorySliderBloc>().add(LoadCategorySlider(languageCode: widget.language));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CategorySliderBloc>()..add(LoadCategorySlider(languageCode: widget.language)),
      child: SafeArea(
        child: BlocBuilder<CategorySliderBloc, CategorySliderState>(
          builder: (context, state) {
            if (state is CategorySliderLoading) {
              return const Center(
                child: CupertinoActivityIndicator(radius: 14, color: Color(0xFF0A84FF)),
              );
            } else if (state is CategorySliderError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is CategorySliderLoaded) {
              final cats = state.categories;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 24),
                itemCount: cats.length,
                itemBuilder: (ctx, i) {
                  final cat = cats[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            cat.name.toUpperCase(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: cat.subcategories.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (ctx2, j) {
                              final SubcategoryEntity sub = cat.subcategories[j];
                              final beforeCount = cats
                                  .take(i)
                                  .fold<int>(0, (sum, c) => sum + c.subcategories.length);
                              final globalIndex = beforeCount + j;
                              final imageNumber = (globalIndex % 23) + 1;
                              final assetPath = 'assets/images/$imageNumber.jpeg';
                              return GestureDetector(
                                onTap: () {
                                  if (sub.subcategories != null && sub.subcategories!.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => NestedSubcategoryScreen(
                                          title: sub.name,
                                          subcategories: sub.subcategories!,
                                          language: widget.language,
                                        ),
                                      ),
                                    );
                                  } else if (sub.video != null) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => VideoPlayerScreen(
                                          title: sub.name,
                                          videoUrl: sub.video!,
                                          language: widget.language,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.asset(
                                          assetPath,
                                          width: 140,
                                          height: 180,
                                          fit: BoxFit.cover,
                                          cacheWidth: 1120,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(16),
                                            color: Colors.black.withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Center(
                                          child: Text(
                                            sub.name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}