import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_todolist/models/todo_model.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  static const String TODO_DATE_FORMAT = "yyy-MM-dd";

  final TextEditingController _todoTitleController = TextEditingController();

  List<TodoModel> _todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _createFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: _createTodoList(),
    );
  }

  Widget _createFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Colors.white),
      onPressed: () => {
        _openAddTodoDialog()
      },
    );
  }

  Widget _createTodoList() {
    return ListView.separated(
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return _createTodoCard(_todoList[index]);
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

  void _openAddTodoDialog() {
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

  void _addNewTodo(String title) {
    TodoModel newTodo = TodoModel(title, DateTime.now());
    setState(() {
      _todoList.add(newTodo);
    });
  }
}

