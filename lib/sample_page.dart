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
  List<Category> _categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // generatedTodo();
    getTodo();
  }

  late Repository repo;
  getTodo() async {
    _categories = [];
    repo = Repository();
    List<dynamic> resultTodo = await repo.readData('categories');
    for (var todo in resultTodo) {
      _categories.add(Todo.mapTodo(todo));
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
              child: Text("Category Kosong"),
            )
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return funcCard(index);
              },
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
        title: Text(
          _categories[index].category.toString() ?? "Nothing Category",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
}
