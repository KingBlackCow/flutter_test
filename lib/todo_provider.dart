import 'package:flutter/material.dart';
import 'todo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    loadTodos();
  }

  void addTodo(String title) {
    _todos.add(Todo(title: title));
    saveTodos();
    notifyListeners();
  }

  void toggleTodo(Todo todo) {
    todo.isDone = !todo.isDone;
    saveTodos();
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _todos.remove(todo);
    saveTodos();
    notifyListeners();
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoList = _todos.map((todo) => jsonEncode({
      'title': todo.title,
      'isDone': todo.isDone,
    })).toList();
    prefs.setStringList('todos', todoList);
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todoList = prefs.getStringList('todos');
    if (todoList != null) {
      _todos = todoList.map((item) {
        final map = jsonDecode(item);
        return Todo(title: map['title'], isDone: map['isDone']);
      }).toList();
      notifyListeners();
    }
  }
}