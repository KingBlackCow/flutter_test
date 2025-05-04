import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_page.dart';
import 'todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue, // 앱 기본 색
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const TodoPage(),
      ),
    );
  }
}