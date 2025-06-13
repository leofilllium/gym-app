// lib/presentation/pages/search_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/domain/entities/subcategory_entity.dart';
import 'package:gym_app/presentation/blocs/search/search_bloc.dart';
import 'package:gym_app/presentation/blocs/search/search_event.dart';
import 'package:gym_app/presentation/blocs/search/search_state.dart';
import 'package:gym_app/presentation/pages/video_player_screen.dart';
import 'package:gym_app/service_locator.dart';

class SearchScreen extends StatefulWidget {
  final String language;
  const SearchScreen({Key? key, required this.language}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(LoadAllVideos(languageCode: widget.language));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchBloc>()..add(LoadAllVideos(languageCode: widget.language)),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: CupertinoSearchTextField(
                placeholder: () {
                  switch (widget.language) {
                    case 'ru':
                      return 'Искать';
                    case 'uz':
                      return "Izlash";
                    default:
                      return "Search";
                  }
                }(),
                style: const TextStyle(color: Colors.white),
                onChanged: (q) {
                  context.read<SearchBloc>().add(PerformSearch(query: q));
                },
                onSubmitted: (q) {
                  context.read<SearchBloc>().add(PerformSearch(query: q));
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(radius: 14, color: Color(0xFF0A84FF)),
                    );
                  } else if (state is SearchError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is SearchLoaded) {
                    final results = state.results;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: results.length,
                      itemBuilder: (_, i) {
                        final SubcategoryEntity vid = results[i];
                        return ListTile(
                          title: Text(vid.name, style: const TextStyle(color: Colors.white)),
                          leading: const Icon(CupertinoIcons.play_circle),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => VideoPlayerScreen(
                                  title: vid.name,
                                  videoUrl: vid.video!,
                                  language: widget.language,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}