import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gym_app/presentation/blocs/app_status/app_status_bloc.dart';
import 'package:gym_app/presentation/blocs/app_status/app_status_event.dart'; // Correct import for AppStatusEvent
import 'package:gym_app/presentation/blocs/app_status/app_status_state.dart';
import 'package:gym_app/presentation/pages/auth_screen.dart';
import 'package:gym_app/presentation/pages/language_selection_screen.dart';
import 'package:gym_app/presentation/pages/navigation_screen.dart';
import 'package:gym_app/presentation/pages/splash_screen.dart';
import 'package:gym_app/service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF121212),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppStatusBloc>(
      create: (context) => di.sl<AppStatusBloc>()..add(LoadAppStatus()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RAFIS GYM',
        theme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          primaryColor: const Color(0xFF1C1C1E),
          scaffoldBackgroundColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark().copyWith(
            primary: const Color(0xFF0A84FF),
            secondary: const Color(0xFF64D2FF),
            background: const Color(0xFF121212),
            surface: const Color(0xFF1C1C1E),
            onSurface: Colors.white,
          ),
          cardColor: const Color(0xFF1C1C1E),
          dividerColor: Colors.white12,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            titleLarge: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'SF Pro Display',
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
            color: const Color(0xFF1C1C1E),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1C1C1E),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            iconTheme: IconThemeData(
              color: Color(0xFF0A84FF),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0A84FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ru', ''),
          Locale('uz', ''),
        ],
        home: BlocBuilder<AppStatusBloc, AppStatusState>(
          builder: (context, state) {
            if (state is AppStatusLoading) {
              return const SplashScreen();
            } else if (state is AppStatusLanguageUnselected) {
              return LanguageSelectionScreen(
                onLanguageSelected: (language) {
                  context
                      .read<AppStatusBloc>()
                      .add(SaveLanguageEvent(language));
                },
              );
            } else if (state is AppStatusUnauthenticated) {
              return AuthScreen(
                language: state.selectedLanguage,
                onAuthenticated: (uuid) {
                  context.read<AppStatusBloc>().add(SaveUuidEvent(uuid));
                },
              );
            } else if (state is AppStatusAuthenticated) {
              return NavigationScreen(language: state.selectedLanguage);
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}