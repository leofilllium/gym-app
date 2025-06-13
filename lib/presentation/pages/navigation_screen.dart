// lib/presentation/pages/navigation_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_bloc.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_bloc.dart';
import 'package:gym_app/presentation/blocs/search/search_bloc.dart';
import 'package:gym_app/presentation/pages/category_slider_screen.dart';
import 'package:gym_app/presentation/pages/main_screen.dart';
import 'package:gym_app/presentation/pages/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/service_locator.dart';


class NavigationScreen extends StatefulWidget {
  final String language;
  const NavigationScreen({Key? key, required this.language}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _pages = [
    BlocProvider(
      create: (context) => sl<MainScreenBloc>(),
      child: MainScreen(language: widget.language),
    ),
    BlocProvider(
      create: (context) => sl<CategorySliderBloc>(),
      child: CategorySliderScreen(language: widget.language),
    ),
    BlocProvider(
      create: (context) => sl<SearchBloc>(),
      child: SearchScreen(language: widget.language),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1C1C1E),
        selectedItemColor: const Color(0xFF0A84FF),
        unselectedItemColor: Colors.grey[400],
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_grid_2x2),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.slider_horizontal_3),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: '',
          ),
        ],
      ),
    );
  }
}