import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_list/add_todo_page.dart';
import 'package:todo_list/detail_todo_page.dart';
import 'package:todo_list/model/todolist_model.dart';

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
    generatedTodo();
  }

  void generatedTodo() {
    _list = [
      Todo(
          id: 1,
          title: "Kuliah",
          description: "Mencari Relasi",
          category: "Kuliah di Poliwangi",
          date: "12-12-2012",
          isFinished: 0),
      Todo(
          id: 2,
          title: "Kerja",
          description: "Mencari Uang",
          category: "Kerja di Blibli.com",
          date: "12-12-20202",
          isFinished: 0),
      Todo(
          id: 3,
          title: "Liburan",
          description: "Mencari Pahala",
          category: "liburan di Makkah & Madinah",
          date: "12-12-2030",
          isFinished: 0),
    ];
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
      body: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            elevation: 8.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: ListTile(
              onTap: () async {
                int temp = index;
                Todo updateItem = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailTodoPage(
                              currentTodo: _list[index],
                            )));
                log("halaman home${updateItem.title}");
                setState(() {
                  _list[temp] = updateItem;
                });
              },
              onLongPress: () {
                log("Deleting this todo");
                removeTodoAlert(context, index);
              },
              title: Text(
                _list[index].title ?? "No Title",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                _list[index].description ?? "No Descriptioin",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                _list[index].date ?? "No Date",
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          Todo newTodo = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTodoPage(),
              ));

          setState(() {
            _list.add(newTodo);
          });
        },
        tooltip: 'TodoLIst',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
      child: const Text("Hapus"),
      onPressed: () {
        setState(() {
          _list.removeAt(index);
        });
        Navigator.of(context).pop();
      },
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
