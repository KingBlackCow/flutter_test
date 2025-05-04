import 'package:flutter/material.dart';
import 'todo.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(Todo(title: _controller.text));
        _controller.clear();
      });
      saveTodos();
    }
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    saveTodos();
  }

  void _removeTodo(Todo todo) {
    setState(() {
      _todos.remove(todo);
    });
    saveTodos();
  }

  // 할 일 목록 저장
  void saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoList = _todos.map((todo) => jsonEncode({
      'title': todo.title,
      'isDone': todo.isDone,
    })).toList();
    prefs.setStringList('todos', todoList);
  }

// 할 일 목록 불러오기
  void loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todoList = prefs.getStringList('todos');
    if (todoList != null) {
      setState(() {
        _todos.clear();
        _todos.addAll(todoList.map((item) {
          final map = jsonDecode(item);
          return Todo(title: map['title'], isDone: map['isDone']);
        }));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos = provider.todos;
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Todo List")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(labelText: '할 일 입력'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      provider.addTodo(controller.text);
                      controller.clear();
                    }
                  },
                  child: Text("추가"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  key: ValueKey(todo.title),
                  leading: Icon(
                    todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: todo.isDone ? Colors.green : Colors.grey,
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isDone ? TextDecoration.lineThrough : TextDecoration.none,
                      color: todo.isDone ? Colors.grey : Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => provider.removeTodo(todo),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
