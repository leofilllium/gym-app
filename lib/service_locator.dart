import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/core/localization/app_localization.dart';
import 'package:gym_app/data/datasources/local/auth_local_datasource.dart';
import 'package:gym_app/data/datasources/remote/auth_remote_datasource.dart';
import 'package:gym_app/data/datasources/remote/category_remote_datasource.dart';
import 'package:gym_app/data/repositories/auth_repository_impl.dart';
import 'package:gym_app/data/repositories/category_repository_impl.dart';
import 'package:gym_app/domain/repositories/auth_repository.dart';
import 'package:gym_app/domain/repositories/category_repository.dart';
import 'package:gym_app/domain/usecases/auth/get_saved_language.dart';
import 'package:gym_app/domain/usecases/auth/get_saved_uuid.dart';
import 'package:gym_app/domain/usecases/auth/remove_language.dart';
import 'package:gym_app/domain/usecases/auth/save_language.dart';
import 'package:gym_app/domain/usecases/auth/save_uuid.dart';
import 'package:gym_app/domain/usecases/auth/validate_uuid.dart';
import 'package:gym_app/domain/usecases/category/get_categories.dart';
import 'package:gym_app/presentation/blocs/app_status/app_status_bloc.dart';
import 'package:gym_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:gym_app/presentation/blocs/category_slider/category_slider_bloc.dart';
import 'package:gym_app/presentation/blocs/main_screen/main_screen_bloc.dart';
import 'package:gym_app/presentation/blocs/search/search_bloc.dart';
import 'package:gym_app/presentation/blocs/video_player/video_player_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - App Status / Auth / Categories / Search / Video Player

  // Bloc
  sl.registerFactory(
        () => AppStatusBloc(
      getSavedUuid: sl(),
      validateUuid: sl(),
      getSavedLanguage: sl(),
      saveLanguageUseCase: sl(), // Inject the UseCase
      saveUuidUseCase: sl(), // Inject the UseCase
    ),
  );
  sl.registerFactory(
        () => AuthBloc(
      validateUuid: sl(),
      saveUuid: sl(),
      appLocalization: sl(),
    ),
  );
  sl.registerFactory(
        () => CategorySliderBloc(
      getCategories: sl(),
    ),
  );
  sl.registerFactory(
        () => MainScreenBloc(
      getCategories: sl(),
      removeLanguage: sl(),
      appLocalization: sl(),
    ),
  );
  sl.registerFactory(
        () => SearchBloc(
      getCategories: sl(),
    ),
  );
  sl.registerFactoryParam<VideoPlayerCubit, String, void>(
        (videoUrl, _) => VideoPlayerCubit(videoUrl: videoUrl, appLocalization: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSavedUuid(sl()));
  sl.registerLazySingleton(() => ValidateUuid(sl()));
  sl.registerLazySingleton(() => SaveUuid(sl())); // The UseCase
  sl.registerLazySingleton(() => GetSavedLanguage(sl()));
  sl.registerLazySingleton(() => SaveLanguage(sl())); // The UseCase
  sl.registerLazySingleton(() => RemoveLanguage(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CategoryRepository>(
        () => CategoryRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
        () => CategoryRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  sl.registerLazySingleton(() => AppLocalization());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
}