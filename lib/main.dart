import 'package:flutter/material.dart';
import 'package:todo_db/pages/todo.dart';
import 'package:todo_db/pages/settings.dart';
import 'package:todo_db/functions/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),

      ],
      child: MaterialApp(
        initialRoute: '/todo',
        routes: {
          '/todo': (context) => Home(),
          '/settings': (context) => Settings(),
        },
      ),
    );
  }
}
