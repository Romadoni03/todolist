import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list/add_todo_page.dart';
import 'package:todo_list/detail_todo_page.dart';
import 'package:todo_list/model/todolist_model.dart';
import 'package:todo_list/repository/repository.dart';
import 'package:todo_list/sample_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  List<Todo> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // generatedTodo();
    getTodo();
  }

  late Repository repo;
  getTodo() async {
    _list = [];
    repo = Repository();
    List<dynamic> resultTodo = await repo.readData('todo');
    for (var todo in resultTodo) {
      _list.add(Todo.mapTodo(todo));
    }
    setState(() {
      _list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "TodoList App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: (_list.isEmpty)
          ? const Center(
              child: Text("Todo List Kosong"),
            )
          : ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                return funcCard(index);
              },
            ),
      floatingActionButton: funcFloatingActionButton(),
      drawer: funcDrawer(),
    );
  }

  Drawer funcDrawer() {
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
              color: Colors.blue,
            ),
            title: const Text(
              'Todo-List',
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('Categories'),
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SamplePage(),
                  ),
                );
              }),
        ],
      ),
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
        onTap: () async {
          log("from home page :");
          log(_list[index].category.toString());
          Todo updateItem = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTodoPage(
                currentTodo: _list[index],
              ),
            ),
          );

          if (updateItem != null) {
            getTodo();
          }
        },
        onLongPress: () {
          log(_list[index].id.toString());
          removeTodoAlert(context, index);
        },
<<<<<<< HEAD
        leading: Container(
          width: MediaQuery.of(context).size.width / 10,
          child: Text(
            _list[index].category.toString() ?? "No Title",
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          _list[index].title.toString() ?? "No Title",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
=======
        title: Text(
          _list[index].title.toString() ?? "No Title",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
>>>>>>> 210177cd307436354bb2535b73b6e1b6731445d7
        subtitle: Text(
          _list[index].description ?? "No Descriptioin",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          _list[index].date ?? "No Date",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  FloatingActionButton funcFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      onPressed: () async {
        Todo newTodo = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoPage(),
            ));
        getTodo();
      },
      tooltip: 'TodoLIst',
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  removeTodoAlert(BuildContext context, index) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      onPressed: () async {
        log(_list[index].id.toString());
        await repo.deleteData('todo', _list[index].id);
        getTodo();
        Navigator.of(context).pop();
      },
      child: const Text("Hapus"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Peringatan"),
      content: const Text("Apakah anda ingin menghapus Todo ini ?"),
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
}
