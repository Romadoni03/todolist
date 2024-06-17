class Category {
  int? id;
  String? category;

  Category({this.id, this.category});

  static mapTodo(map) {
    Category newCategory = Category();
    newCategory.id = map['id'];
    newCategory.category = map['category'];

    return newCategory;
  }

  static todoMap(item) {
    var mapping = <String, dynamic>{};
    mapping['id'] = item.id;
    mapping['category'] = item.category;

    return mapping;
  }
}
