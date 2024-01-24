import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {

  String getTodoListTitle() {
    
    if (selectedLanguage == 'Русский') {
      return 'Список дел';
    } else if (selectedLanguage == 'English') {
      return 'Todo List';
    }
    return 'Список дел'; 
  }

   String getEditingTodoListDialog() {
    
    if (selectedLanguage == 'Русский') {
      return 'Редактирование заметки';
    } else if (selectedLanguage == 'English') {
      return 'Note editing';
    }
    return 'Редактирование заметки'; 
  }

  String getEditingTodoListButton() {
    
    if (selectedLanguage == 'Русский') {
      return 'Сохранить';
    } else if (selectedLanguage == 'English') {
      return 'Save';
    }
    return 'Сохранить'; 
  }

  String getAdditionTodoListDialog() {
    
    if (selectedLanguage == 'Русский') {
      return 'Добавление заметки';
    } else if (selectedLanguage == 'English') {
      return 'Note addition';
    }
    return 'Добавление заметки'; 
  }

  String getAdditionTodoListButton() {
    
    if (selectedLanguage == 'Русский') {
      return 'Добавить';
    } else if (selectedLanguage == 'English') {
      return 'Add';
    }
    return 'Добавить'; 
  }

  String getSettingsThemeTitle() {
    
    if (selectedLanguage == 'Русский') {
      return 'Настройки';
    } else if (selectedLanguage == 'English') {
      return 'Settings';
    }
    return 'Настройки'; 
  }

  String getSettingsTheme() {
    
    if (selectedLanguage == 'Русский') {
      return 'Тёмная тема';
    } else if (selectedLanguage == 'English') {
      return 'Dark mode';
    }
    return 'Тёмная тема'; 
  }

  String getSettingsLanguage() {
    
    if (selectedLanguage == 'Русский') {
      return 'Язык';
    } else if (selectedLanguage == 'English') {
      return 'Language';
    }
    return 'Язык'; 
  }

  



final Color _dropdownBackgroundColorLight = Colors.white;
final Color _dropdownTextColorLight = Colors.lightBlueAccent;
final Color _dropdownBackgroundColorLightEnabled = Colors.white;
final Color _dropdownTextColorLightEnabled = Colors.lightBlueAccent;
final Color _dropdownTextColorMenuLight = Colors.white;

final Color _dropdownBackgroundColorDark = Colors.black;
final Color _dropdownTextColorDark = Colors.deepPurple.shade200;
final Color _dropdownBackgroundColorDarkEnabled = Colors.black;
final Color _dropdownTextColorDarkEnabled = Colors.deepPurple.shade200;
final Color _dropdownTextColorMenuDark = Colors.black;

  Color get dropdownBackgroundColor =>
      _isDarkThemeEnabled ? _dropdownBackgroundColorDark : _dropdownBackgroundColorLight;

  Color get dropdownTextColor =>
      _isDarkThemeEnabled ? _dropdownTextColorDark : _dropdownTextColorLight;

  Color get dropdownBackgroundColorEnabled =>
      _isDarkThemeEnabled ? _dropdownBackgroundColorDarkEnabled : _dropdownBackgroundColorLightEnabled;

  Color get dropdownTextColorEnabled =>
      _isDarkThemeEnabled ? _dropdownTextColorDarkEnabled : _dropdownTextColorLightEnabled;

  Color get dropdownTextColorMenu =>
      _isDarkThemeEnabled ? _dropdownTextColorMenuDark : _dropdownTextColorMenuLight;

  bool _isDarkThemeEnabled = false;
  String _selectedLanguage = 'Русский';
  final List<String> _languages = ['Русский', 'English'];

  bool get isDarkThemeEnabled => _isDarkThemeEnabled;
  String get selectedLanguage => _selectedLanguage;
  List<String> get languages => _languages;

  static const String _darkThemeKey = 'darkTheme';
  static const String _selectedLanguageKey = 'selectedLanguage';

  // Light Theme Colors
static final ThemeData _lightTheme = ThemeData(
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.lightBlueAccent,
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.lightBlueAccent),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.lightBlueAccent,
    foregroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  cardColor: Colors.lightBlueAccent,
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent.withOpacity(0.5)),
    thumbColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.lightBlueAccent.withOpacity(0.5);
        }
        return Colors.lightBlueAccent;
      },
    ),
    overlayColor: MaterialStateProperty.all<Color>(Colors.lightBlueAccent.withOpacity(0.2)),
  ),
);

  // Dark Theme Colors
static final ThemeData _darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme:  AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.deepPurple.shade200,
    ),
    actionsIconTheme: IconThemeData(
      color: Colors.deepPurple.shade200,
    ),
  ),
  textTheme:  TextTheme(
    bodyText1: TextStyle(color: Colors.black),
    bodyText2: TextStyle(color: Colors.deepPurple.shade200),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.deepPurple.shade200,
    foregroundColor: Colors.black,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  cardColor: Colors.deepPurple.shade200,
  switchTheme: SwitchThemeData(
    trackColor: MaterialStateProperty.all<Color>(Colors.deepPurple.shade200.withOpacity(0.5)),
    thumbColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Colors.deepPurple.shade200.withOpacity(0.5);
        }
        return Colors.deepPurple.shade200;
      },
    ),
    overlayColor: MaterialStateProperty.all<Color>(Colors.deepPurple.shade200.withOpacity(0.2)),
  ),
);


  ThemeData get currentTheme {
    return _isDarkThemeEnabled ? _darkTheme : _lightTheme;
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkThemeEnabled = prefs.getBool(_darkThemeKey) ?? false;
    _selectedLanguage = prefs.getString(_selectedLanguageKey) ?? 'Русский';
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_darkThemeKey, _isDarkThemeEnabled);
    prefs.setString(_selectedLanguageKey, _selectedLanguage);
  }

  void toggleTheme() {
    _isDarkThemeEnabled = !_isDarkThemeEnabled;
    _saveSettings();
    notifyListeners();
  }

 void setSelectedLanguage(String language) {
  _selectedLanguage = language;
  _saveSettings();
  notifyListeners();
}
 
  ThemeProvider() {
    _loadSettings();
  }

  
}



