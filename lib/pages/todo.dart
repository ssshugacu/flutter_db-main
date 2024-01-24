import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_db/functions/theme_provider.dart';
import 'package:todo_db/pages/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _userToDo;
  List<String> todoList = [];

  Future<void> saveNote(String todo) async {
  const String apiUrl = 'http://192.168.1.26:7000/task';
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWFmNjU3MTFhYTFhMTExY2IxN2E3NWMiLCJpYXQiOjE3MDU5OTM1ODUsImV4cCI6MTcwNjU5ODM4NX0.NMZb0YDXmvIjs470Djmzs6eM-dyK-KqDqkiX5COGMUc',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'text': todo}),
    );

    if (response.statusCode == 200) {
      print('Заметка успешно сохранена');
    } else {
      print('Ошибка при сохранении заметки: ${response.body}');
    }
  } catch (e) {
    print('Ошибка: $e');
  }
}

Future<void> saveList(List<String> todoList) async {
  for (String todo in todoList) {
    await saveNote(todo);
  }
}

  Future<void> getList() async {
    try {
      const String apiUrl = 'http://192.168.1.26:7000/task/all';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWFmNjU3MTFhYTFhMTExY2IxN2E3NWMiLCJpYXQiOjE3MDU5OTM1ODUsImV4cCI6MTcwNjU5ODM4NX0.NMZb0YDXmvIjs470Djmzs6eM-dyK-KqDqkiX5COGMUc',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          Map<String, dynamic> responseMap = jsonDecode(response.body);

  List<String> namesList = [];

  if (responseMap.containsKey('tasks')) {
    List<dynamic> tasks = responseMap['tasks'];

    for (var task in tasks) {
      if (task.containsKey('name')) {
        namesList.add(task['name']);
      }
    }
  }

  print(namesList);

          todoList = namesList;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNote(int taskId) async {
  const String apiUrl = 'http://192.168.1.26:7000/task/:taskId';
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/$taskId'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWFmNjU3MTFhYTFhMTExY2IxN2E3NWMiLCJpYXQiOjE3MDU5OTM1ODUsImV4cCI6MTcwNjU5ODM4NX0.NMZb0YDXmvIjs470Djmzs6eM-dyK-KqDqkiX5COGMUc',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Заметка успешно удалена');
    } else {
      print('Ошибка при удалении заметки: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка: $e');
  }
}


  Future<void> editNote(int taskId, String updatedTask) async {
  const String apiUrl = 'http://192.168.1.26:7000/task/:taskId';
  try {
    final response = await http.put(
      Uri.parse('$apiUrl/$taskId'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NWFmNjU3MTFhYTFhMTExY2IxN2E3NWMiLCJpYXQiOjE3MDU5OTM1ODUsImV4cCI6MTcwNjU5ODM4NX0.NMZb0YDXmvIjs470Djmzs6eM-dyK-KqDqkiX5COGMUc',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'todo': updatedTask}),
    );

    if (response.statusCode == 200) {
      print('Заметка успешно отредактирована');
    } else {
      print('Ошибка при редактировании заметки: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка: $e');
  }
}


  Route _settingsRoute(BuildContext context) {
    return MaterialPageRoute(
      builder: (context) {
        return Settings();
      },
    );
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.settings,
                    color: themeProvider
                        .currentTheme.appBarTheme.iconTheme?.color),
                onPressed: () {
                  Navigator.push(context, _settingsRoute(context));
                },
              ),
            ],
            backgroundColor:
                themeProvider.currentTheme.appBarTheme.backgroundColor,
            bottomOpacity: 0.0,
            elevation: 0.0,
            title: Text(themeProvider.getTodoListTitle(),
                style: TextStyle(
                    color:
                        themeProvider.currentTheme.textTheme.bodyText2?.color)),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(todoList[index]),
                child: Card(
                  color: themeProvider.currentTheme.cardColor,
                  child: ListTile(
                    title: Text(
                      todoList[index],
                      style: TextStyle(
                          fontSize: 30,
                          color: themeProvider
                              .currentTheme.textTheme.bodyText1?.color),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_sweep,
                            color: themeProvider.currentTheme.iconTheme.color,
                          ),
                          onPressed: () {
                            deleteNote(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: themeProvider.currentTheme.iconTheme.color,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String updatedTask = todoList[index];
                                return AlertDialog(
                                  backgroundColor: themeProvider
                                      .currentTheme
                                      .floatingActionButtonTheme
                                      .backgroundColor,
                                  title: Text(
                                    themeProvider.getEditingTodoListDialog(),
                                    style: TextStyle(
                                        color: themeProvider.currentTheme
                                            .textTheme.bodyText1?.color),
                                  ),
                                  content: TextField(
                                    onChanged: (String value) {
                                      updatedTask = value;
                                    },
                                    controller: TextEditingController(
                                        text: todoList[index]),
                                    style: TextStyle(
                                        color: themeProvider
                                            .currentTheme
                                            .textTheme
                                            .bodyText1
                                            ?.color), // Цвет текста в поле ввода
                                    cursorColor: themeProvider.currentTheme
                                            .textTheme.bodyText1?.color ??
                                        Colors.white, // Цвет подсветки
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: themeProvider
                                                    .currentTheme
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color ??
                                                Colors
                                                    .white), // Цвет подсветки при фокусе
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: themeProvider
                                                    .currentTheme
                                                    .textTheme
                                                    .bodyText1
                                                    ?.color ??
                                                Colors
                                                    .white), // Цвет подсветки в статичном положении
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          todoList[index] = updatedTask;
                                          saveList(todoList);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        themeProvider
                                            .getEditingTodoListButton(),
                                        style: TextStyle(
                                            color: themeProvider.currentTheme
                                                .textTheme.bodyText2?.color),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          themeProvider
                                              .currentTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  deleteNote(index);
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: themeProvider
                .currentTheme.floatingActionButtonTheme.backgroundColor,
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: themeProvider
                        .currentTheme.floatingActionButtonTheme.backgroundColor,
                    title: Text(
                      themeProvider.getAdditionTodoListDialog(),
                      style: TextStyle(
                          color: themeProvider
                              .currentTheme.textTheme.bodyText1?.color),
                    ),
                    content: TextField(
                      onChanged: (String value) {
                        _userToDo = value;
                      },
                      style: TextStyle(
                          color: themeProvider.currentTheme.textTheme.bodyText1
                              ?.color), // Цвет текста в поле ввода
                      cursorColor: themeProvider.currentTheme.textTheme
                          .bodyText1?.color, // Цвет подсветки
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: themeProvider.currentTheme.textTheme
                                      .bodyText1?.color ??
                                  Colors.white), // Цвет подсветки при фокусе
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: themeProvider.currentTheme.textTheme
                                      .bodyText1?.color ??
                                  Colors
                                      .white), // Цвет подсветки в статичном положении
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todoList.add(_userToDo);
                            saveList(todoList);
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          themeProvider.getAdditionTodoListButton(),
                          style: TextStyle(
                              color: themeProvider
                                  .currentTheme.textTheme.bodyText2?.color),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            themeProvider.currentTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.add,
                size: 30.0,
                color: themeProvider
                    .currentTheme.floatingActionButtonTheme.foregroundColor),
          ),
        );
      },
    );
  }
}
