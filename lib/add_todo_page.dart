// ignore_for_file: unnecessary_import

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/model/categories_model.dart';
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
  final _date = TextEditingController();

  List _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    getCategoires();
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
      for (var x in _categories) {
        log(x.id.toString());
        log(x.category.toString());
      }
    });
  }

  _addTodoList() async {
    Todo newTodo = Todo(
      title: _title.text,
      description: _description.text,
      category: _selectedCategory,
      date: _date.text,
      isFinished: 0,
    );
    log("before from add page");

    Repository repo = Repository();
    var result = await repo.insertData('todo', Todo.todoMap(newTodo));

    if (result > 0) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, newTodo);
      log("sukses");
      log("category Id : ${newTodo.categoryId}");
    } else {
      // ignore: prefer_interpolation_to_compose_strings
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
            DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((item) => DropdownMenuItem<String>(
                          value: item.category,
                          child: Text(item.category.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    log(value.toString());
                    _selectedCategory = value.toString();
                  });
                }),
            TextField(
              controller: _date,
              decoration: InputDecoration(
                labelText: "Date",
                hintText: "Date",
                prefixIcon: InkWell(
                  onTap: () {
                    _selectTodoDate(context);
                  },
                  child: const Icon(Icons.calendar_today),
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
