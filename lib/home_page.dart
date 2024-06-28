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
  List<Todo> _listIsFinished1 = [];
  List<Todo> _listIsFinishedSelesai = [];

  List finishedOption = ["Semua", "Belum selesai", "Selesai"];
  String finishedValue = "Semua";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // generatedTodo();
    getTodo();
    getTodoisFinished();
    getTodoisFinishedSelesai();
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
      finishedValue;
    });
  }

  getTodoisFinished() async {
    _listIsFinished1 = [];
    repo = Repository();
    List<dynamic> resultTodo = await repo.readDataByIsFinished('todo', '0');
    for (var todo in resultTodo) {
      _listIsFinished1.add(Todo.mapTodo(todo));
    }
    setState(() {
      log("message");
      _listIsFinished1;
    });
  }

  getTodoisFinishedSelesai() async {
    _listIsFinishedSelesai = [];
    repo = Repository();
    List<dynamic> resultTodo = await repo.readDataByIsFinished('todo', '1');
    for (var todo in resultTodo) {
      _listIsFinishedSelesai.add(Todo.mapTodo(todo));
    }
    setState(() {
      log("message");
      _listIsFinishedSelesai;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "TodoList Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: (_list.isEmpty)
          ? const Center(
              child: Text("Todo List Kosong"),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Todo-List",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      ),
                      DropdownButton(
                        hint: Text(finishedValue),
                        items: finishedOption
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {
                          log("log value $value");
                          setState(() {
                            finishedValue = value.toString();
                          });
                        },
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    if (finishedValue == "Semua")
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ListView.builder(
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return funcCard(index, _list);
                          },
                        ),
                      )
                    else if (finishedValue == "Belum selesai")
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ListView.builder(
                          itemCount: _listIsFinished1.length,
                          itemBuilder: (context, index) {
                            return funcCard(index, _listIsFinished1);
                          },
                        ),
                      )
                    else
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: ListView.builder(
                          itemCount: _listIsFinishedSelesai.length,
                          itemBuilder: (context, index) {
                            return funcCard(index, _listIsFinishedSelesai);
                          },
                        ),
                      )
                  ],
                )
              ],
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

  Card funcCard(index, List<dynamic> listParams) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailTodoPage(
                currentTodo: listParams[index],
              ),
            ),
          );

          getTodo();
          getTodoisFinished();
          getTodoisFinishedSelesai();
        },
        onLongPress: () {
          removeTodoAlert(context, index);
        },
        leading: Container(
          width: MediaQuery.of(context).size.width / 10,
          child: Text(
            listParams[index].category.toString() ?? "No Category",
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          listParams[index].title.toString() ?? "No Title",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _list[index].description ?? "No Descriptioin",
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          listParams[index].date ?? "No Date",
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
        getTodoisFinished();
        getTodoisFinishedSelesai();
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
        getTodoisFinished();
        getTodoisFinishedSelesai();
        // ignore: use_build_context_synchronously
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
