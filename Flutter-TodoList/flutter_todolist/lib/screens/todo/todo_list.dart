import 'package:flutter/material.dart';
import 'package:flutter_todolist/bloc/todo_bloc.dart';
import 'package:flutter_todolist/database/dao/todo_dao.dart';
import 'package:flutter_todolist/repository/todo_repository.dart';
import 'package:intl/intl.dart';
import 'package:flutter_todolist/models/todo_model.dart';

class TodoListPage extends StatelessWidget {
  static const String TODO_DATE_FORMAT = "yyy-MM-dd";

  final TextEditingController _todoTitleController = TextEditingController();
  final TodoBloc _todoBloc = TodoBloc(
      TodoRepository(
          TodoDao()
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _createFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: _createTodoListStreamBuilder(),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () => {
        _openAddTodoDialog(context)
      },
    );
  }

  Widget _createTodoListStreamBuilder() {
    return StreamBuilder(
        stream: _todoBloc.todoListStream,
        builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _createTodoList(snapshot.data);
            } else {
              return Container();
            }
          } else {
            return Container();
          }
        }
    );
  }

  Widget _createTodoList(List<TodoModel> todoList) {
    return ListView.separated(
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return _createTodoCard(todoList[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          thickness: 8.0,
          height: 8.0,
          color: Colors.transparent,
        );
      },
    );
  }

  Widget _createTodoCard(TodoModel todoModel) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child:
      Container(padding: EdgeInsets.all(16.0), child: _createTodoItemRow(todoModel)),
    );
  }

  Widget _createTodoItemRow(TodoModel todoModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _createTodoItemContentWidget(todoModel),
        Icon(Icons.keyboard_arrow_right, color: Colors.blue)
      ],
    );
  }

  Widget _createTodoItemContentWidget(TodoModel todoModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            todoModel.getTitle(),
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.blue
            )
        ),
        Divider(
          thickness: 8.0,
          height: 8.0,
          color: Colors.transparent,
        ),
        Text(
            DateFormat(TODO_DATE_FORMAT).format(todoModel.getCreatedTime()),
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.blueGrey
            )
        )
      ],
    );
  }

  void _openAddTodoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            title: Text(
              "할일을 입력해주세요.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: Colors.blue
              ),
            ),
            content: TextField(
              controller: _todoTitleController,
            ),
            actions: [
              FlatButton(
                child: new Text(
                  "취소",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.red
                  ),
                ),
                onPressed: () {
                  _todoTitleController.text = "";
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: new Text(
                  "추가",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue
                  ),
                ),
                onPressed: () {
                  _addNewTodo(_todoTitleController.text);
                  _todoTitleController.text = "";
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  void _addNewTodo(String title) async {
    TodoModel newTodo = TodoModel(null, title, DateTime.now(), TodoState.todo);
    _todoBloc.addTodo(newTodo);
  }
}


