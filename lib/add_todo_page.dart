import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/model/todolist_model.dart';
import 'package:todo_list/repository/repository.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _date = TextEditingController();

  _addTodoList() async {
    Todo newTodo = Todo(
      title: _title.text,
      description: _description.text,
      category: _category.text,
      date: _date.text,
      isFinished: 0,
    );

    log("proses");

    Repository repo = Repository();
    var result = await repo.insertData('todos', Todo.todoMap(newTodo));

    if (result > 0) {
      Navigator.pop(context, newTodo);
      log("sukses");
    } else {
      log("Data is not created. Result value : " + result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Page Add Todo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Title",
              ),
            ),
            TextField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Description",
              ),
            ),
            TextField(
              controller: _category,
              decoration: const InputDecoration(
                labelText: "Category",
                hintText: "Category",
              ),
            ),
            TextField(
              controller: _date,
              decoration: InputDecoration(
                labelText: "Date",
                hintText: "Date",
                prefixIcon: InkWell(
                  onTap: () {
                    _selectTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _addTodoList,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(
                  double.infinity,
                  45,
                ),
              ),
              child: const Text(
                "Add Task",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  _selectTodoDate(BuildContext context) async {
    DateTime dateTime = DateTime.now();
    var pickedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
        _date.text = DateFormat("yyyy-MM-dd").format(pickedDate);
      });
      log(_date.text);
    }
  }
}
