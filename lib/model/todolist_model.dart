class Todo {
  int? id;
  String? title;
  String? description;
  String? category;
  String? date;
  int? isFinished;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.date,
      this.isFinished});

  static mapTodo(map) {
    Todo newTodo = Todo();
    newTodo.id = map['id'];
    newTodo.title = map['title'];
    newTodo.description = map['description'];
    newTodo.category = map['category'];
    newTodo.date = map['date'];
    newTodo.isFinished = map['is_finished'];
    return newTodo;
  }

  static todoMap(item) {
    var mapping = <String, dynamic>{};
    mapping['title'] = item.title;
    mapping['desciption'] = item.description;
    mapping['category'] = item.category;
    mapping['todo_date'] = item.date;
    mapping['is_finished'] = item.isFinished;
    return mapping;
  }
}
