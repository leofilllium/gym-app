class AppLocalization {
  final Map<String, Map<String, String>> localizedValues = {
    'en': {
      'authEnterKey': 'Please enter key',
      'authIncorrectKey': 'Incorrect key',
      'authValidationError': 'Error validating key',
      'authHintText': 'Enter key',
      'authSubmitButton': 'SUBMIT',
      'videoInvalidUrl': 'Invalid video URL',
      'videoTimedOut': 'Video loading timed out',
      'videoFailedToLoad': 'Failed to load video',
      'videoErrorPrefix': 'Error: ',
      'videoRetryButton': 'RETRY',
      'mainFailedToLoadWorkouts': 'Failed to load workouts',
      'mainNoWorkoutsFound': 'No workouts found',
      'mainRetryButton': 'RETRY',
      'selectLanguageTitle': 'SELECT LANGUAGE',
      'train': "TRAIN"
    },
    'ru': {
      'authEnterKey': 'Пожалуйста введите ключ',
      'authIncorrectKey': 'Неправильный ключ',
      'authValidationError': 'Ошибка при валидаций ключа',
      'authHintText': 'Введите ключ',
      'authSubmitButton': 'ОТПРАВИТЬ',
      'videoInvalidUrl': 'Неверный URL видео',
      'videoTimedOut': 'Время загрузки видео истекло',
      'videoFailedToLoad': 'Не удалось загрузить видео',
      'videoErrorPrefix': 'Ошибка: ',
      'videoRetryButton': 'ПОВТОРИТЬ',
      'mainFailedToLoadWorkouts': 'Не удалось загрузить тренировки',
      'mainNoWorkoutsFound': 'Тренировки не найдены',
      'mainRetryButton': 'ПОВТОРИТЬ',
      'selectLanguageTitle': 'ВЫБЕРИТЕ ЯЗЫК',
      'train':'ТРЕНИРУЙСЯ'
    },
    'uz': {
      'authEnterKey': 'Iltimos, kalitni kiriting',
      'authIncorrectKey': 'Noto\'g\'ri kalit',
      'authValidationError': 'Kalitni tasdiqlashda xato',
      'authHintText': 'Kalitni kiriting',
      'authSubmitButton': 'YUBORISH',
      'videoInvalidUrl': 'Video URL manzili noto\'g\'ri',
      'videoTimedOut': 'Video yuklash vaqti tugadi',
      'videoFailedToLoad': 'Videoni yuklab bo\'lmadi',
      'videoErrorPrefix': 'Xato: ',
      'videoRetryButton': 'QAYTA URINISH',
      'mainFailedToLoadWorkouts': 'Mashqlarni yuklab bo\'lmadi',
      'mainNoWorkoutsFound': 'Mashqlar topilmadi',
      'mainRetryButton': 'QAYTA URINISH',
      'selectLanguageTitle': 'TILNI TANLANG',
      'train': 'MASHQ QIL'
    },
  };

  String getLocalizedText(String key, String languageCode) {
    return localizedValues[languageCode]?[key] ??
        localizedValues['en']?[key] ??
        key;
  }
}