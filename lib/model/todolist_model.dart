class Todo {
  int? id;
  String? title;
  String? description;
  String? category;
  int? categoryId;
  String? date;
  int? isFinished;

  Todo(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.categoryId,
      this.date,
      this.isFinished});

  static mapTodo(map) {
    Todo newTodo = Todo();
    newTodo.id = map['id'];
    newTodo.title = map['title'];
    newTodo.description = map['desciption'];
    newTodo.category = map['category'];
    newTodo.categoryId = map['category_id'];
    newTodo.date = map['todo_date'];
    newTodo.isFinished = map['is_finished'];
    return newTodo;
  }

  static todoMap(item) {
    var mapping = <String, dynamic>{};
    mapping['id'] = item.id;
    mapping['title'] = item.title;
    mapping['desciption'] = item.description;
    mapping['category'] = item.category;
    mapping['category_id'] = item.categoryId;
    mapping['todo_date'] = item.date;
    mapping['is_finished'] = item.isFinished;
    return mapping;
  }
}
