import 'dart:async';
import 'package:flutter_todolist/database/database.dart';
import 'package:flutter_todolist/models/todo_model.dart';

class TodoDao {
  final dbProvider = DatabaseProvider.provider;

  Future<int> createTodo(TodoModel todo) async {
    final db = await dbProvider.database;
    final result = db.insert(todoTable, todo.toDatabaseJson());
    return result;
  }

  Future<List<TodoModel>> getTodoList() async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(todoTable);
    List<TodoModel> todoList = result.isNotEmpty ? result.map((item) => TodoModel.fromDatabaseJson(item)).toList() : [];

    return todoList;
  }
}