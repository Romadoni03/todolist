import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:todo_list/model/categories_model.dart';
import 'package:todo_list/model/todolist_model.dart';
import 'package:todo_list/repository/repository.dart';

class SamplePage extends StatefulWidget {
  SamplePage({super.key});

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  final _name = TextEditingController();
  final _nameUpdate = TextEditingController();
  List<Category> _categories = [];
  List<Todo> list = [];
  int? result;

  _addCategory() async {
    Category newCategory = Category(category: _name.text);
    repo = Repository();
    var result = await repo.insertData(
      'categories',
      Category.todoMap(newCategory),
    );
    if (result > 0) {
      log("sukses add new category");
      Navigator.pop(context);
      getCategoires();
    } else {
      log("Failed. Result value : {$result}");
      Navigator.pop(context);
    }
  }

  getTodoByCategory(categoryText) async {
    list = [];
    repo = Repository();
    List<dynamic> resultTodo =
        await repo.readTodoByCategory('todo', categoryText);
    for (var todo in resultTodo) {
      list.add(Todo.mapTodo(todo));
    }
    setState(() {
      result = list.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // generatedTodo();
    getCategoires();
    getTodoByCategory;
  }

  late Repository repo;
  getCategoires() async {
    _categories = [];
    repo = Repository();
    List<dynamic> resultCategories = await repo.readData('categories');
    for (var category in resultCategories) {
      _categories.add(Category.mapTodo(category));
    }
    setState(() {
      _categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Category Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: (_categories.isEmpty)
          ? const Center(
              child: Text("Nothing Categories"),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return funcCard(index);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          setState(() {
            funcShowDialog(context);
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      drawer: funcDrawer(context),
    );
  }

  Card funcCard(index) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListTile(
        leading: IconButton(
            onPressed: () {
              _nameUpdate.text = _categories[index].category.toString();
              updateCategory(context, index);
            },
            icon: const Icon(
              Icons.edit,
              color: Colors.black,
            )),
        title: Text(
          _categories[index].category.toString() ?? "Nothing Category",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          onPressed: () async {
            await getTodoByCategory(_categories[index].category);
            log(result.toString());
            if (result != 0) {
              useCategoryAlert();
              log("category masih digunakan di todolist");
            } else {
              removeCategoryAlert(context, index);
              log("delete category");
            }
          },
          icon: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Drawer funcDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            currentAccountPicture: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                backgroundImage: AssetImage("images/profile.jpg"),
              ),
            ),
            accountEmail: const Text("mriskiromadoni03@gmail.com"),
            accountName: const Text("RISKI TAKA"),
          ),
          ListTile(
              leading: const Icon(
                Icons.calendar_month_outlined,
              ),
              title: const Text(
                'Todo-List',
              ),
              onTap: () {
                Navigator.pop(context);
                backHomePage(context);
              }),
          ListTile(
            leading: const Icon(
              Icons.view_list,
              color: Colors.blue,
            ),
            title: const Text(
              'Categories',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  backHomePage(BuildContext context) {
    Navigator.pop(context);
  }

  funcShowDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Category"),
          content: TextField(
            controller: _name,
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Category",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                log("Batal");
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: _addCategory,
              child: const Text("Add"),
            )
          ],
        );
      },
    );
  }

  removeCategoryAlert(BuildContext context, index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      onPressed: () async {
        log(_categories[index].id.toString());
        await repo.deleteData('categories', _categories[index].id);
        getCategoires();
        Navigator.of(context).pop();
      },
      child: const Text("Hapus"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text("Deletet this category ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  useCategoryAlert() {
    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Oke"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: const Text("Category ini sedang digunakan di todolist"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  updateCategory(BuildContext context, index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Category"),
          content: TextField(
            controller: _nameUpdate,
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Category",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                log("Batal");
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                log(_categories[index].id.toString());
                log(_nameUpdate.text.toString());
                Category updateCategory = Category(
                  id: _categories[index].id,
                  category: _nameUpdate.text.toString(),
                );

                Repository repo = Repository();
                repo.updateCategoryTodo(
                    'todo',
                    _categories[index].category.toString(),
                    _nameUpdate.text.toString());
                repo.updateData('categories', Category.todoMap(updateCategory));
                log(_categories[index].category.toString());
                log(_nameUpdate.text);
                Navigator.pop(context);
                getCategoires();
              },
              child: const Text("Update"),
            )
          ],
        );
      },
    );
  }
}
