// lib/data/datasources/local/auth_local_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_app/core/errors/failures.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUuid(String uuid);
  Future<String?> getSavedUuid();
  Future<void> saveLanguage(String languageCode);
  Future<String?> getSavedLanguage();
  Future<void> removeLanguage();
}

const CACHED_UUID = 'uuid';
const CACHED_LANGUAGE = 'language';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getSavedUuid() {
    try {
      return Future.value(sharedPreferences.getString(CACHED_UUID));
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> saveUuid(String uuid) {
    try {
      return sharedPreferences.setString(CACHED_UUID, uuid);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<String?> getSavedLanguage() {
    try {
      return Future.value(sharedPreferences.getString(CACHED_LANGUAGE));
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> saveLanguage(String languageCode) {
    try {
      return sharedPreferences.setString(CACHED_LANGUAGE, languageCode);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }

  @override
  Future<void> removeLanguage() {
    try {
      return sharedPreferences.remove(CACHED_LANGUAGE);
    } catch (e) {
      throw CacheFailure(message: e.toString());
    }
  }
}