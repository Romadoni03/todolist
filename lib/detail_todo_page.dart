import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/model/categories_model.dart';
import 'package:todo_list/model/todolist_model.dart';

import 'package:todo_list/repository/repository.dart';

// ignore: must_be_immutable
class DetailTodoPage extends StatefulWidget {
  Todo currentTodo;
  DetailTodoPage({super.key, required this.currentTodo});

  @override
  State<DetailTodoPage> createState() => _DetailTodoPageState();
}

class _DetailTodoPageState extends State<DetailTodoPage> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _category = TextEditingController();
  final _date = TextEditingController();
  final _isFinished = TextEditingController();

  List _categories = [];

  late Todo _currentItem;
  bool isDisabled = false;
  bool updateButtonState = true;
  bool returnButtonState = false;

  List finishedOption = ["Belum selesai", "Selesai"];
  String finishedValue = "";
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.currentTodo;
    // log("halaman update" + _currentItem.title.toString());
    getCategoires();
    setData();
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

  void setData() {
    _title.text = _currentItem.title.toString();
    _description.text = _currentItem.description.toString();
    _category.text = _currentItem.category.toString();
    _date.text = _currentItem.date.toString();
    _isFinished.text = _currentItem.isFinished.toString();
    finishedValue = finishedOption[int.parse(_isFinished.text)];
    _selectedCategory = _category.text.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Page Detail Todo",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              enabled: isDisabled,
              controller: _title,
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Title",
              ),
            ),
            TextField(
              enabled: isDisabled,
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
              onChanged: isDisabled
                  ? (value) {
                      setState(() {
                        log(value.toString());
                        _selectedCategory = value.toString();
                      });
                    }
                  : null,
            ),
            TextField(
              enabled: isDisabled,
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
            funcButtonTheme(),
            const SizedBox(
              height: 20,
            ),
            funcElevatedButtonUpdate(),
            funcElevatedButtonUpdateReturn()
          ],
        ),
      ),
    );
  }

  ButtonTheme funcButtonTheme() {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
            label: Text("is Finished"),
            labelStyle: TextStyle(color: Color.fromARGB(255, 170, 168, 162))),
        value: finishedValue,
        items: finishedOption
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        hint: const Text('Category'),
        onChanged: isDisabled
            ? (value) {
                setState(() {
                  finishedValue = value.toString();
                });
              }
            : null,
      ),
    );
  }

  ElevatedButton funcElevatedButtonUpdate() {
    return ElevatedButton(
      onPressed: updateButtonState
          ? () {
              setState(() {
                isDisabled = true;
                updateButtonState = false;
                returnButtonState = true;
              });
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(
          double.infinity,
          45,
        ),
      ),
      child: const Text(
        "Update",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  ElevatedButton funcElevatedButtonUpdateReturn() {
    return ElevatedButton(
      onPressed: returnButtonState
          ? () {
              Todo updateTodo = Todo(
                id: _currentItem.id,
                title: _title.text.toString(),
                category: _selectedCategory.toString(),
                categoryId: _categories.indexWhere(
                    (category) => category.category == _selectedCategory),
                description: _description.text.toString(),
                date: _date.text.toString(),
                isFinished: finishedOption.indexOf(finishedValue),
              );
              Repository repo = Repository();
              repo.updateData('todo', Todo.todoMap(updateTodo));
              log("todo : update");
              log(updateTodo.id.toString());
              log(updateTodo.title.toString());
              log(updateTodo.description.toString());
              log(updateTodo.category.toString());
              log(updateTodo.categoryId.toString());
              log(updateTodo.date.toString());
              log(updateTodo.isFinished.toString());
              Navigator.pop(context, updateTodo);
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 202, 208, 212),
        minimumSize: const Size(
          double.infinity,
          45,
        ),
      ),
      child: const Text(
        "Update and Return",
        style: TextStyle(color: Colors.black),
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
