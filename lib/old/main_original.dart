// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//
// // --- Localization Helper Function ---
// // This function provides localized strings based on a given key and language code.
// // It uses a map to store translations for English, Russian, and Uzbek.
// String getLocalizedText(String key, String languageCode) {
//   final Map<String, Map<String, String>> localizedValues = {
//     'en': {
//       'authEnterKey': 'Please enter key',
//       'authIncorrectKey': 'Incorrect key',
//       'authValidationError': 'Error validating key',
//       'authHintText': 'Enter key',
//       'authSubmitButton': 'SUBMIT',
//       'videoInvalidUrl': 'Invalid video URL',
//       'videoTimedOut': 'Video loading timed out',
//       'videoFailedToLoad': 'Failed to load video',
//       'videoErrorPrefix': 'Error: ',
//       'videoRetryButton': 'RETRY',
//       'mainFailedToLoadWorkouts': 'Failed to load workouts',
//       'mainNoWorkoutsFound': 'No workouts found',
//       'mainRetryButton': 'RETRY',
//       'selectLanguageTitle': 'SELECT LANGUAGE',
//     },
//     'ru': {
//       'authEnterKey': 'Пожалуйста введите ключ',
//       'authIncorrectKey': 'Неправильный ключ',
//       'authValidationError': 'Ошибка при валидаций ключа',
//       'authHintText': 'Введите ключ',
//       'authSubmitButton': 'ОТПРАВИТЬ',
//       'videoInvalidUrl': 'Неверный URL видео',
//       'videoTimedOut': 'Время загрузки видео истекло',
//       'videoFailedToLoad': 'Не удалось загрузить видео',
//       'videoErrorPrefix': 'Ошибка: ',
//       'videoRetryButton': 'ПОВТОРИТЬ',
//       'mainFailedToLoadWorkouts': 'Не удалось загрузить тренировки',
//       'mainNoWorkoutsFound': 'Тренировки не найдены',
//       'mainRetryButton': 'ПОВТОРИТЬ',
//       'selectLanguageTitle': 'ВЫБЕРИТЕ ЯЗЫК',
//     },
//     'uz': {
//       'authEnterKey': 'Iltimos, kalitni kiriting',
//       'authIncorrectKey': 'Noto\'g\'ri kalit',
//       'authValidationError': 'Kalitni tasdiqlashda xato',
//       'authHintText': 'Kalitni kiriting',
//       'authSubmitButton': 'YUBORISH',
//       'videoInvalidUrl': 'Video URL manzili noto\'g\'ri',
//       'videoTimedOut': 'Video yuklash vaqti tugadi',
//       'videoFailedToLoad': 'Videoni yuklab bo\'lmadi',
//       'videoErrorPrefix': 'Xato: ',
//       'videoRetryButton': 'QAYTA URINISH',
//       'mainFailedToLoadWorkouts': 'Mashqlarni yuklab bo\'lmadi',
//       'mainNoWorkoutsFound': 'Mashqlar topilmadi',
//       'mainRetryButton': 'QAYTA URINISH',
//       'selectLanguageTitle': 'TILNI TANLANG',
//     },
//   };
//
//   // Fallback to English if the specific language or key is not found,
//   // otherwise return the key itself as a last resort.
//   return localizedValues[languageCode]?[key] ?? localizedValues['en']?[key] ?? key;
// }
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.light,
//     systemNavigationBarColor: Color(0xFF121212),
//     systemNavigationBarIconBrightness: Brightness.light,
//   ));
//   runApp(const MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String? selectedLanguage;
//   bool isLoading = true;
//   bool? isAuthenticated; // null: unknown, true: authenticated, false: not authenticated
//   bool _isLanguageSelected = false; // New state to track if language is selected
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAppState();
//   }
//
//   // Loads the application's state, checking for saved authentication and language.
//   Future<void> _loadAppState() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final savedUuid = prefs.getString('uuid');
//       final savedLanguage = prefs.getString('language');
//
//       if (savedUuid != null) {
//         // If a UUID is saved, assume they are authenticated for UI flow.
//         // The background validation will check if the UUID is still active.
//         setState(() {
//           isAuthenticated = true; // Assume authenticated if UUID exists
//           if (savedLanguage != null) {
//             selectedLanguage = savedLanguage;
//             _isLanguageSelected = true;
//           }
//         });
//
//         // Optionally, validate UUID in the background without blocking the UI.
//         // If validation fails, it might indicate a revoked key, but per user request,
//         // we won't force re-authentication immediately if a UUID was already present.
//         _validateUuid(savedUuid).then((isValid) {
//           if (!isValid) {
//             // This print statement is for debugging/logging purposes.
//             // In a real app, you might show a subtle warning or handle it differently
//             // without forcing the user back to the auth screen unless absolutely necessary.
//             print('Warning: Saved UUID validation failed in background, but proceeding as authenticated.');
//             // If you *did* want to force re-auth on a failed background validation,
//             // you would call prefs.remove('uuid') here and then trigger a rebuild.
//             // However, the current request is to *not* re-auth if previously authorized.
//           }
//         });
//
//       } else {
//         // No UUID saved, so the user is not authenticated.
//         setState(() {
//           isAuthenticated = false;
//         });
//       }
//     } catch (e) {
//       // Handle any errors during shared preferences access.
//       setState(() {
//         isAuthenticated = false;
//       });
//     } finally {
//       // Once loading is complete, set isLoading to false.
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   // Saves the selected language to SharedPreferences and updates the state.
//   Future<void> _saveLanguage(String language) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language', language);
//     setState(() {
//       selectedLanguage = language;
//       _isLanguageSelected = true;
//     });
//   }
//
//   // Saves the authenticated UUID to SharedPreferences and updates the state.
//   Future<void> _saveUuid(String uuid) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('uuid', uuid);
//     setState(() {
//       isAuthenticated = true;
//     });
//   }
//
//   // Validates the provided UUID by calling an external API.
//   Future<bool> _validateUuid(String uuid) async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://tradingai.academytable.ru/validate'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'uuid': uuid}),
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return data['valid'] == true;
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'RAFIS GYM',
//       theme: ThemeData.dark().copyWith(
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         primaryColor: const Color(0xFF1C1C1E),
//         scaffoldBackgroundColor: const Color(0xFF121212),
//         colorScheme: const ColorScheme.dark().copyWith(
//           primary: const Color(0xFF0A84FF),
//           secondary: const Color(0xFF64D2FF),
//           background: const Color(0xFF121212),
//           surface: const Color(0xFF1C1C1E),
//           onSurface: Colors.white,
//         ),
//         cardColor: const Color(0xFF1C1C1E),
//         dividerColor: Colors.white12,
//         textTheme: const TextTheme(
//           displayLarge: TextStyle(
//             fontFamily: 'SF Pro Display',
//             fontSize: 34.0,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             letterSpacing: -0.5,
//           ),
//           titleLarge: TextStyle(
//             fontFamily: 'SF Pro Display',
//             fontSize: 20.0,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//             letterSpacing: -0.5,
//           ),
//           bodyLarge: TextStyle(
//             fontFamily: 'SF Pro Display',
//             fontSize: 16.0,
//             fontWeight: FontWeight.w400,
//             color: Colors.white,
//             letterSpacing: -0.3,
//           ),
//         ),
//         cardTheme: CardTheme(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.0),
//           ),
//           elevation: 0,
//           color: const Color(0xFF1C1C1E),
//         ),
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xFF1C1C1E),
//           elevation: 0,
//           centerTitle: true,
//           titleTextStyle: TextStyle(
//             color: Colors.white,
//             fontSize: 17,
//             fontWeight: FontWeight.w600,
//             letterSpacing: -0.5,
//           ),
//           iconTheme: IconThemeData(
//             color: Color(0xFF0A84FF),
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white,
//             backgroundColor: const Color(0xFF0A84FF),
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//             textStyle: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               letterSpacing: -0.3,
//             ),
//           ),
//         ),
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//       ),
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('en', ''),
//         Locale('ru', ''),
//         Locale('uz', ''),
//       ],
//       // Determines which screen to show based on loading, language selection, and authentication status.
//       home: isLoading
//           ? const SplashScreen() // Show splash screen while loading
//           : !_isLanguageSelected // If language not selected, show language selection screen
//           ? LanguageSelectionScreen(onLanguageSelected: _saveLanguage)
//           : (isAuthenticated == null || isAuthenticated == false) // If language selected but not authenticated, show auth screen
//           ? AuthScreen(onAuthenticated: _saveUuid, language: selectedLanguage!)
//           : NavigationScreen(language: selectedLanguage!), // If both language selected and authenticated, show main navigation
//     );
//   }
// }
//
// class AuthScreen extends StatefulWidget {
//   final Function(String) onAuthenticated;
//   final String language; // Pass language to AuthScreen for localization
//
//   const AuthScreen({Key? key, required this.onAuthenticated, required this.language}) : super(key: key);
//
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   final TextEditingController _uuidController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   // Validates the UUID entered by the user.
//   Future<void> _validateUuid() async {
//     final uuid = _uuidController.text.trim();
//     if (uuid.isEmpty) {
//       setState(() {
//         _errorMessage = getLocalizedText('authEnterKey', widget.language); // Localized error message
//       });
//       return;
//     }
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse('https://tradingai.academytable.ru/validate'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({'uuid': uuid}),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['valid'] == true) {
//           widget.onAuthenticated(uuid);
//         } else {
//           setState(() {
//             _errorMessage = getLocalizedText('authIncorrectKey', widget.language); // Localized error message
//             _isLoading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _errorMessage = getLocalizedText('authValidationError', widget.language); // Localized error message
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = '${getLocalizedText('videoErrorPrefix', widget.language)}$e'; // Localized error prefix
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: SafeArea(
//         top: true,
//         bottom: false,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 60),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'RAFIS GYM',
//                     style: Theme.of(context).textTheme.displayLarge?.copyWith(
//                       color: Colors.white,
//                       fontSize: 42,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: -1,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     getLocalizedText('authHintText', widget.language), // Localized text
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       color: Colors.grey[400],
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 60),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1C1C1E),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: _uuidController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: getLocalizedText('authHintText', widget.language), // Localized hint text
//                         hintStyle: TextStyle(color: Colors.grey[400]),
//                         filled: true,
//                         fillColor: const Color(0xFF2C2C2E),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       onSubmitted: (_) => _validateUuid(),
//                     ),
//                     if (_errorMessage != null) ...[
//                       const SizedBox(height: 16),
//                       Text(
//                         _errorMessage!,
//                         style: const TextStyle(
//                           color: Colors.redAccent,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: 24),
//                     _isLoading
//                         ? const CupertinoActivityIndicator(
//                       radius: 14,
//                       color: Color(0xFF0A84FF),
//                     )
//                         : ElevatedButton(
//                       onPressed: _validateUuid,
//                       child: Text(getLocalizedText('authSubmitButton', widget.language)), // Localized button text
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: const Size(double.infinity, 50),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _uuidController.dispose();
//     super.dispose();
//   }
// }
//
// class NavigationScreen extends StatefulWidget {
//   final String language;
//   const NavigationScreen({Key? key, required this.language}) : super(key: key);
//
//   @override
//   _NavigationScreenState createState() => _NavigationScreenState();
// }
//
// class _NavigationScreenState extends State<NavigationScreen> {
//   int _currentIndex = 0;
//
//   late final List<Widget> _pages = [
//     MainScreen(language: widget.language),
//     CategorySliderScreen(language: widget.language),
//     SearchScreen(language: widget.language),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         backgroundColor: const Color(0xFF1C1C1E),
//         selectedItemColor: const Color(0xFF0A84FF),
//         unselectedItemColor: Colors.grey[400],
//         onTap: (i) => setState(() => _currentIndex = i),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.square_grid_2x2),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.slider_horizontal_3),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(CupertinoIcons.search),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class CategorySliderScreen extends StatelessWidget {
//   final String language;
//
//   const CategorySliderScreen({Key? key, required this.language}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: FutureBuilder<List<Category>>(
//         future: fetchCategories(language),
//         builder: (context, snap) {
//           if (snap.connectionState != ConnectionState.done) {
//             return const Center(
//               child: CupertinoActivityIndicator(radius: 14, color: Color(0xFF0A84FF)),
//             );
//           }
//           final cats = snap.data ?? [];
//           return ListView.builder(
//             padding: const EdgeInsets.symmetric(vertical: 24),
//             itemCount: cats.length,
//             itemBuilder: (ctx, i) {
//               final cat = cats[i];
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 32),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       child: Text(
//                         cat.name.toUpperCase(),
//                         style: Theme.of(context).textTheme.titleLarge,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     SizedBox(
//                       height: 180,
//                       child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         padding: const EdgeInsets.symmetric(horizontal: 24),
//                         itemCount: cat.subcategories.length,
//                         separatorBuilder: (_, __) => const SizedBox(width: 16),
//                         itemBuilder: (ctx2, j) {
//                           final sub = cat.subcategories[j];
//                           final beforeCount = cats
//                               .take(i)
//                               .fold<int>(0, (sum, c) => sum + c.subcategories.length);
//                           final globalIndex = beforeCount + j;
//                           final imageNumber = (globalIndex % 23) + 1;
//                           final assetPath = 'assets/images/$imageNumber.jpeg';
//                           return GestureDetector(
//                             onTap: () {
//                               if (sub.subcategories != null && sub.subcategories!.isNotEmpty) {
//                                 Navigator.push(
//                                   context,
//                                   CupertinoPageRoute(
//                                     builder: (_) => NestedSubcategoryScreen(
//                                       title: sub.name,
//                                       subcategories: sub.subcategories!,
//                                       language: language,
//                                     ),
//                                   ),
//                                 );
//                               } else if (sub.video != null) {
//                                 Navigator.push(
//                                   context,
//                                   CupertinoPageRoute(
//                                     builder: (_) => VideoPlayerScreen(
//                                       title: sub.name,
//                                       videoUrl: sub.video!,
//                                       language: language, // Pass language
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                             child: Container(
//                               width: 140,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               alignment: Alignment.center,
//                               child: Stack(
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(16),
//                                     child: Image.asset(
//                                       assetPath,
//                                       width: 140,
//                                       height: 180,
//                                       fit: BoxFit.cover,
//                                       // Force respecting original orientation
//                                       cacheWidth: 1120, // 2x for high-resolution displays
//                                     ),
//                                   ),
//                                   // Dark overlay
//                                   Positioned.fill(
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(16),
//                                         color: Colors.black.withOpacity(0.4),
//                                       ),
//                                     ),
//                                   ),
//                                   // Text
//                                   Positioned.fill(
//                                     child: Center(
//                                       child: Text(
//                                         sub.name,
//                                         textAlign: TextAlign.center,
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class SearchScreen extends StatefulWidget {
//   final String language;
//   const SearchScreen({Key? key, required this.language}) : super(key: key);
//
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   List<Subcategory> _allVideos = [];
//   List<Subcategory> _results = [];
//   String _query = '';
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories(widget.language).then((cats) {
//       final vids = <Subcategory>[];
//       void collect(List<Subcategory> subs) {
//         for (var s in subs) {
//           if (s.video != null) vids.add(s);
//           if (s.subcategories != null) collect(s.subcategories!);
//         }
//       }
//       collect(cats.expand((c) => c.subcategories).toList());
//       setState(() {
//         _allVideos = vids;
//         _results = vids;
//       });
//     });
//   }
//
//   void _onSearch(String q) {
//     setState(() {
//       _query = q;
//       _results = _allVideos
//           .where((v) => v.name.toLowerCase().contains(q.toLowerCase()))
//           .toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: CupertinoSearchTextField(
//               placeholder: () {
//                 switch (widget.language) {
//                   case 'ru':
//                     return 'Искать';
//                   case 'uz':
//                     return "Izlash";
//                   default:
//                     return "Search";
//                 }
//               }(),
//               style: const TextStyle(color: Colors.white),
//               onChanged: _onSearch,
//               onSubmitted: _onSearch,
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               itemCount: _results.length,
//               itemBuilder: (_, i) {
//                 final vid = _results[i];
//                 return ListTile(
//                   title: Text(vid.name, style: const TextStyle(color: Colors.white)),
//                   leading: const Icon(CupertinoIcons.play_circle),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       CupertinoPageRoute(
//                         builder: (_) => VideoPlayerScreen(
//                           title: vid.name,
//                           videoUrl: vid.video!,
//                           language: widget.language, // Pass language
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'RAFIS GYM',
//               style: Theme.of(context).textTheme.displayLarge?.copyWith(
//                 color: Colors.white,
//                 fontSize: 42,
//                 fontWeight: FontWeight.w900,
//                 letterSpacing: -1,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const CupertinoActivityIndicator(
//               radius: 14,
//               color: Color(0xFF0A84FF),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LanguageSelectionScreen extends StatelessWidget {
//   final Function(String) onLanguageSelected;
//
//   const LanguageSelectionScreen({
//     Key? key,
//     required this.onLanguageSelected,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Determine the current locale to display the correct "SELECT LANGUAGE" text
//     final String currentLocale = Localizations.localeOf(context).languageCode;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF121212),
//       body: SafeArea(
//         top: true,
//         bottom: false,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 60),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'RAFIS GYM',
//                     style: Theme.of(context).textTheme.displayLarge?.copyWith(
//                       color: Colors.white,
//                       fontSize: 42,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: -1,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     getLocalizedText('selectLanguageTitle', currentLocale), // Localized title
//                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       color: Colors.grey[400],
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 60),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1C1C1E),
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     _buildLanguageButton(context, 'ENGLISH', 'en'),
//                     const SizedBox(height: 16),
//                     _buildLanguageButton(context, 'РУССКИЙ', 'ru'),
//                     const SizedBox(height: 16),
//                     _buildLanguageButton(context, "O'ZBEK", 'uz'),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLanguageButton(BuildContext context, String label, String langCode) {
//     return Container(
//       width: double.infinity,
//       height: 65,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         border: Border.all(
//           color: const Color(0xFF0A84FF),
//           width: 1.5,
//         ),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () => onLanguageSelected(langCode),
//           borderRadius: BorderRadius.circular(16),
//           child: Center(
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Color(0xFF0A84FF),
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: -0.3,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Future<List<Category>> fetchCategories(String language) async {
//   try {
//     final response = await http.get(
//       Uri.parse('http://tradingai.academytable.ru/$language.json'),
//     );
//     if (response.statusCode == 200) {
//       final decoded = utf8.decode(response.bodyBytes);
//       final Map<String, dynamic> data = json.decode(decoded);
//       if (data['categories'] == null) {
//         throw Exception('No categories found in response');
//       }
//       final List<dynamic> categoriesJson = data['categories'];
//       return categoriesJson
//           .map((json) => Category.fromJson(json as Map<String, dynamic>))
//           .toList();
//     } else {
//       throw Exception(
//           'Failed to load categories (status: ${response.statusCode})');
//     }
//   } catch (e) {
//     throw Exception('Error fetching categories: $e');
//   }
// }
//
// class MainScreen extends StatefulWidget {
//   final String language;
//
//   const MainScreen({
//     Key? key,
//     required this.language,
//   }) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   late Future<List<Category>> futureCategories;
//   List<Category> _filteredCategories = [];
//   String _searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     futureCategories = fetchCategories(widget.language);
//     futureCategories.then((cats) {
//       setState(() {
//         _filteredCategories = cats;
//       });
//     });
//   }
//
//   void _onSearchChanged(String query) {
//     setState(() {
//       _searchQuery = query;
//       futureCategories.then((cats) {
//         _filteredCategories = cats
//             .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         top: true,
//         bottom: false,
//         child: Column(
//           children: [
//             _buildAppBar(context),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
//               child: CupertinoSearchTextField(
//                 placeholder: () {
//                   switch (widget.language) {
//                     case 'ru':
//                       return 'Искать';
//                     case 'uz':
//                       return "Izlash";
//                     default:
//                       return "Search";
//                   }
//                 }(),
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: _onSearchChanged,
//                 onSubmitted: _onSearchChanged,
//               ),
//             ),
//             Expanded(
//               child: FutureBuilder<List<Category>>(
//                 future: futureCategories,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(
//                       child: CupertinoActivityIndicator(
//                         radius: 14,
//                         color: Color(0xFF0A84FF),
//                       ),
//                     );
//                   } else if (snapshot.hasError) {
//                     return _buildErrorState(context);
//                   } else if (snapshot.hasData) {
//                     final categories = _searchQuery.isEmpty
//                         ? snapshot.data!
//                         : _filteredCategories;
//                     return ListView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 24),
//                       itemCount: categories.length,
//                       itemBuilder: (context, index) {
//                         return CategoryCard(
//                           category: categories[index],
//                           language: widget.language,
//                         );
//                       },
//                     );
//                   }
//                   return Center(child: Text(getLocalizedText('mainNoWorkoutsFound', widget.language))); // Localized text
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildErrorState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             CupertinoIcons.exclamationmark_circle,
//             color: Colors.grey[400],
//             size: 48,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             getLocalizedText('mainFailedToLoadWorkouts', widget.language), // Localized text
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge
//                 ?.copyWith(color: Colors.grey[400]),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 futureCategories = fetchCategories(widget.language);
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(120, 44),
//             ),
//             child: Text(getLocalizedText('mainRetryButton', widget.language)), // Localized text
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAppBar(BuildContext context) {
//     String title = 'TRAIN';
//     switch (widget.language) {
//       case 'ru':
//         title = 'ТРЕНИРУЙСЯ';
//         break;
//       case 'uz':
//         title = 'MASHQ QIL';
//         break;
//     }
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 32,
//               fontWeight: FontWeight.w900,
//               letterSpacing: -1,
//             ),
//           ),
//           _buildLanguageSwitcher(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLanguageSwitcher() => Container(
//     decoration: BoxDecoration(
//       shape: BoxShape.circle,
//       border: Border.all(color: const Color(0xFF0A84FF), width: 1),
//     ),
//     child: IconButton(
//       icon: const Icon(
//           CupertinoIcons.globe,
//           size: 20,
//           color: Color(0xFF0A84FF)),
//       onPressed: () async {
//         final prefs = await SharedPreferences.getInstance();
//         // Only remove the language, keep the UUID to avoid re-authentication
//         await prefs.remove('language');
//         if (!mounted) return;
//         // Navigate to MyApp to re-evaluate the state and prompt for language selection
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const MyApp()),
//         );
//       },
//     ),
//   );
// }
//
// class CategoryCard extends StatelessWidget {
//   final Category category;
//   final String language;
//
//   const CategoryCard({
//     Key? key,
//     required this.category,
//     required this.language,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final label = (() {
//       switch (language) {
//         case 'uz':
//           return 'video';
//         case 'ru':
//           return 'видео';
//         default:
//           return 'videos';
//       }
//     })();
//     IconData iconData;
//
//     switch (category.name.toLowerCase()) {
//       case 'bomb sets':
//       case 'бомбовые сеты':
//       case "bomba to'plamlari":
//         iconData = Icons.whatshot;
//         break;
//       case 'hernia':
//       case 'грыжа':
//       case "grija":
//         iconData = Icons.health_and_safety;
//         break;
//       case 'for the full':
//       case 'для полных':
//       case "to'liqlar uchun":
//         iconData = Icons.accessibility_new;
//         break;
//       case 'home workouts':
//       case 'домашние тренировки':
//       case "uy mashg'ulotlari":
//         iconData = Icons.home;
//         break;
//       case 'mesomorph':
//       case 'мезаморф':
//       case 'mezamorf':
//         iconData = Icons.fitness_center;
//         break;
//       case 'press':
//       case 'пресс':
//       case 'press':
//         iconData = Icons.sports_gymnastics;
//         break;
//       case 'proper nutrition diet':
//       case 'рацион правильного питания':
//       case "to'g'ri ovqatlanish dietasi":
//         iconData = Icons.restaurant_menu;
//         break;
//       case 'sports supplements':
//       case 'спортивные добавки':
//       case "sport qo'shimchalar":
//         iconData = Icons.local_pharmacy;
//         break;
//       case 'ectomorph':
//       case 'эктоморф':
//       case 'ektomorf':
//         iconData = Icons.accessibility;
//         break;
//       case 'endomorph':
//       case 'эндоморф':
//       case 'endomorf':
//         iconData = Icons.directions_run;
//         break;
//       default:
//         iconData = Icons.sports;
//     }
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             offset: const Offset(0, 2),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (_) => SubcategoryScreen(
//                   category: category,
//                   language: language,
//                 ),
//               ),
//             );
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2C2C2E),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(iconData, size: 28, color: const Color(0xFF0A84FF)),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         category.name.toUpperCase(),
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         '${_countTotalItems(category)} $label',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const Icon(CupertinoIcons.chevron_right,
//                     size: 16, color: Color(0xFF0A84FF)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   int _countTotalItems(Category category) {
//     var count = 0;
//     for (var sub in category.subcategories) {
//       if (sub.video != null) count++;
//       if (sub.subcategories != null) {
//         for (var subSub in sub.subcategories!) {
//           if (subSub.video != null) count++;
//           if (subSub.subcategories != null) {
//             count += subSub.subcategories!.length;
//           }
//         }
//       }
//     }
//     return count;
//   }
// }
//
// class SubcategoryScreen extends StatelessWidget {
//   final Category category;
//   final String language;
//
//   const SubcategoryScreen({
//     Key? key,
//     required this.category,
//     required this.language,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(category.name.toUpperCase()),
//         leading: IconButton(
//           icon: const Icon(CupertinoIcons.back, size: 24),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(24),
//         itemCount: category.subcategories.length,
//         itemBuilder: (context, index) {
//           final subcategory = category.subcategories[index];
//           return _buildSubcategoryItem(context, subcategory);
//         },
//       ),
//     );
//   }
//
//   Widget _buildSubcategoryItem(BuildContext context, Subcategory subcategory) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             offset: const Offset(0, 2),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           onTap: () {
//             if (subcategory.subcategories != null &&
//                 subcategory.subcategories!.isNotEmpty) {
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => NestedSubcategoryScreen(
//                     title: subcategory.name,
//                     subcategories: subcategory.subcategories!,
//                     language: language,
//                   ),
//                 ),
//               );
//             } else if (subcategory.video != null) {
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => VideoPlayerScreen(
//                     title: subcategory.name,
//                     videoUrl: subcategory.video!,
//                     language: language, // Pass language
//                   ),
//                 ),
//               );
//             }
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF2C2C2E),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     subcategory.subcategories != null &&
//                         subcategory.subcategories!.isNotEmpty
//                         ? CupertinoIcons.folder_fill
//                         : CupertinoIcons.play_circle_fill,
//                     color: const Color(0xFF0A84FF),
//                     size: 24,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         subcategory.name,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                         maxLines: 1,
//                       ),
//                       if (subcategory.subcategories != null &&
//                           subcategory.subcategories!.isNotEmpty)
//                         Text(
//                           '${subcategory.subcategories!.length} ${_getItemsText(language, subcategory.subcategories!.length)}',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[400],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 const Icon(CupertinoIcons.chevron_right,
//                     size: 16, color: Color(0xFF0A84FF)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String _getItemsText(String language, int count) {
//     switch (language) {
//       case 'ru':
//         return count == 1 ? 'элемент' : (count < 5 ? 'элемента' : 'элементов');
//       case 'uz':
//         return 'element' + (count == 1 ? '' : 'lar');
//       default:
//         return count == 1 ? 'item' : 'items';
//     }
//   }
// }
//
// class NestedSubcategoryScreen extends StatelessWidget {
//   final String title;
//   final List<Subcategory> subcategories;
//   final String language;
//
//   const NestedSubcategoryScreen({
//     Key? key,
//     required this.title,
//     required this.subcategories,
//     required this.language,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title.toUpperCase()),
//         leading: IconButton(
//           icon: const Icon(CupertinoIcons.back, size: 24),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(24),
//         itemCount: subcategories.length,
//         itemBuilder: (context, index) {
//           final subcategory = subcategories[index];
//           return _buildNestedSubcategoryItem(context, subcategory);
//         },
//       ),
//     );
//   }
//
//   Widget _buildNestedSubcategoryItem(
//       BuildContext context, Subcategory subcategory) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1C1C1E),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             offset: const Offset(0, 2),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.circular(16),
//         child: InkWell(
//           onTap: () {
//             if (subcategory.subcategories != null &&
//                 subcategory.subcategories!.isNotEmpty) {
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => NestedSubcategoryScreen(
//                     title: subcategory.name,
//                     subcategories: subcategory.subcategories!,
//                     language: language,
//                   ),
//                 ),
//               );
//             } else if (subcategory.video != null) {
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => VideoPlayerScreen(
//                     title: subcategory.name,
//                     videoUrl: subcategory.video!,
//                     language: language, // Pass language
//                   ),
//                 ),
//               );
//             }
//           },
//           borderRadius: BorderRadius.circular(16),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: subcategory.video != null
//                         ? const Color(0xFF0A84FF)
//                         : const Color(0xFF2C2C2E),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Icon(
//                     subcategory.video != null
//                         ? CupertinoIcons.play_fill
//                         : CupertinoIcons.folder_fill,
//                     color: subcategory.video != null
//                         ? Colors.white
//                         : const Color(0xFF0A84FF),
//                     size: 22,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     subcategory.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const Icon(CupertinoIcons.chevron_right,
//                     size: 16, color: Color(0xFF0A84FF)),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String title;
//   final String videoUrl;
//   final String language; // Add language parameter
//
//   const VideoPlayerScreen({
//     Key? key,
//     required this.title,
//     required this.videoUrl,
//     required this.language, // Initialize language
//   }) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isLoading = true;
//   bool _hasError = false;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   Future<void> _initializePlayer() async {
//     if (widget.videoUrl.isEmpty || !Uri.parse(widget.videoUrl).isAbsolute) {
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//         _errorMessage = getLocalizedText('videoInvalidUrl', widget.language); // Localized error
//       });
//       return;
//     }
//
//     try {
//       final Uri uri = Uri.parse(widget.videoUrl);
//       final encodedUrl = Uri(
//         scheme: uri.scheme,
//         host: uri.host,
//         port: uri.port,
//         path: uri.path,
//         queryParameters: uri.queryParameters,
//       ).toString();
//
//       _videoPlayerController = VideoPlayerController.network(encodedUrl);
//
//       _videoPlayerController.addListener(_onVideoError);
//
//       await _videoPlayerController.initialize().timeout(
//         const Duration(seconds: 30),
//         onTimeout: () {
//           throw TimeoutException(getLocalizedText('videoTimedOut', widget.language)); // Localized timeout message
//         },
//       );
//
//       if (!mounted) return;
//
//       _chewieController = ChewieController(
//         videoPlayerController: _videoPlayerController,
//         autoPlay: true,
//         looping: false,
//         allowFullScreen: true,
//         allowMuting: true,
//         showControls: true,
//         aspectRatio: _videoPlayerController.value.aspectRatio,
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Colors.black,
//           handleColor: Colors.black,
//           backgroundColor: Colors.grey[300]!,
//           bufferedColor: Colors.grey[600]!,
//         ),
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.black, size: 36),
//                 const SizedBox(height: 12),
//                 Text(
//                   '${getLocalizedText('videoErrorPrefix', widget.language)}$errorMessage', // Localized error prefix
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//           _errorMessage = e is TimeoutException
//               ? e.message
//               : '${getLocalizedText('videoErrorPrefix', widget.language)}$e'; // Localized error prefix
//         });
//       }
//     }
//   }
//
//   void _onVideoError() {
//     if (_videoPlayerController.value.hasError && mounted) {
//       setState(() {
//         _hasError = true;
//         _errorMessage = '${getLocalizedText('videoErrorPrefix', widget.language)}${_videoPlayerController.value.errorDescription}'; // Localized error prefix
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.removeListener(_onVideoError);
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.title.toUpperCase(),
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, size: 18),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(
//         child: CupertinoActivityIndicator(
//           radius: 14,
//           color: Color(0xFF0A84FF),
//         ),
//       )
//           : _hasError
//           ? Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.error_outline,
//                 color: Color(0xFF0A84FF),
//                 size: 48,
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 _errorMessage ?? getLocalizedText('videoFailedToLoad', widget.language), // Localized error
//                 style: const TextStyle(
//                   color: Color(0xFF0A84FF),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _isLoading = true;
//                     _hasError = false;
//                     _errorMessage = null;
//                   });
//                   _initializePlayer();
//                 },
//                 child: Text(getLocalizedText('videoRetryButton', widget.language)), // Localized button
//               ),
//             ],
//           ),
//         ),
//       )
//           : _chewieController != null
//           ? Center(
//         child: AspectRatio(
//           aspectRatio: _videoPlayerController.value.aspectRatio,
//           child: Chewie(controller: _chewieController!),
//         ),
//       )
//           : Center(
//         child: Text(getLocalizedText('videoFailedToLoad', widget.language)), // Localized error
//       ),
//     );
//   }
// }
//
// class TimeoutException implements Exception {
//   final String message;
//   TimeoutException(this.message);
//
//   @override
//   String toString() => message;
// }
//
// class Category {
//   final String name;
//   final List<Subcategory> subcategories;
//
//   Category({required this.name, required this.subcategories});
//
//   factory Category.fromJson(Map<String, dynamic> json) {
//     return Category(
//       name: json['name'] ?? 'Unknown',
//       subcategories: (json['subcategories'] as List<dynamic>?)
//           ?.map((subJson) => Subcategory.fromJson(subJson))
//           .toList() ??
//           [],
//     );
//   }
// }
//
// class Subcategory {
//   final String name;
//   final String? video;
//   final List<Subcategory>? subcategories;
//
//   Subcategory({
//     required this.name,
//     this.video,
//     this.subcategories,
//   });
//
//   factory Subcategory.fromJson(Map<String, dynamic> json) {
//     return Subcategory(
//       name: json['name'] ?? 'Unknown',
//       video: json['video'],
//       subcategories: json['subcategories'] != null
//           ? (json['subcategories'] as List<dynamic>)
//           .map((subJson) => Subcategory.fromJson(subJson))
//           .toList()
//           : null,
//     );
//   }
// }