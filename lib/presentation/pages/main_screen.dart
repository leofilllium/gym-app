import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_bloc.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_event.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_state.dart';
import 'package:gym_app/presentation/widgets/category_card.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/main.dart';

class MainScreen extends StatefulWidget {
  final String language;

  const MainScreen({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MainScreenBloc>().add(LoadMainScreenCategories(languageCode: widget.language));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainScreenBloc>()..add(LoadMainScreenCategories(languageCode: widget.language)),
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              _buildAppBar(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
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
                  onChanged: (query) {
                    context.read<MainScreenBloc>().add(FilterCategories(query: query));
                  },
                  onSubmitted: (query) {
                    context.read<MainScreenBloc>().add(FilterCategories(query: query));
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MainScreenBloc, MainScreenState>(
                  builder: (context, state) {
                    if (state is MainScreenLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(
                          radius: 14,
                          color: Color(0xFF0A84FF),
                        ),
                      );
                    } else if (state is MainScreenError) {
                      return _buildErrorState(context, state.message);
                    } else if (state is MainScreenLoaded) {
                      if (state.categories.isEmpty) {
                        return Center(child: Text(sl<AppLocalization>().getLocalizedText('mainNoWorkoutsFound', widget.language)));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return CategoryCard(
                            category: state.categories[index],
                            language: widget.language,
                          );
                        },
                      );
                    } else if (state is MainScreenEmpty) {
                      return Center(child: Text(state.message));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle,
            color: Colors.grey[400],
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<MainScreenBloc>().add(LoadMainScreenCategories(languageCode: widget.language));
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 44),
            ),
            child: Text(sl<AppLocalization>().getLocalizedText('mainRetryButton', widget.language)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    String title = sl<AppLocalization>().getLocalizedText('train', widget.language);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          // _buildLanguageSwitcher(),
        ],
      ),
    );
  }

  // Widget _buildLanguageSwitcher() => Container(
  //   decoration: BoxDecoration(
  //     shape: BoxShape.circle,
  //     border: Border.all(color: const Color(0xFF0A84FF), width: 1),
  //   ),
  //   child: IconButton(
  //     icon: const Icon(CupertinoIcons.globe, size: 20, color: Color(0xFF0A84FF)),
  //     onPressed: () {
  //       context.read<MainScreenBloc>().add(ResetLanguage());
  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(builder: (context) => const MyApp()),
  //       );
  //     },
  //   ),
  // );
}