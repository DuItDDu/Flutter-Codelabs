
import 'dart:async';

import 'package:flutter_todolist/models/todo_model.dart';
import 'package:flutter_todolist/repository/todo_repository.dart';

class TodoBloc {
  final TodoRepository _todoRepository;
  final StreamController<List<TodoModel>> _todoController = StreamController<List<TodoModel>>.broadcast();

  get todoListStream => _todoController.stream;

  TodoBloc(this._todoRepository) {
    getTodoList();
  }

  void getTodoList() async {
    List<TodoModel> todoList = await _todoRepository.getTodoList();
    _todoController.sink.add(todoList);
  }

  void addTodo(TodoModel todo) async {
    await _todoRepository.createTodo(todo);
    getTodoList();
  }
}