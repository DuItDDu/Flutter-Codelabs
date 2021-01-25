class TodoModel {
  String _title;
  TodoState _state;

  final DateTime _createdTime;
  
  TodoModel(this._title, this._createdTime) {
    _state = TodoState.todo;
  }

  String getTitle() => _title;
  DateTime getCreatedTime() => _createdTime;
  TodoState getTodoState() => _state;

  String setTitle(String title) => _title = title;
  TodoState setTodoState(TodoState state) => _state = state;
}

enum TodoState {
  todo, inProgress, done
}