import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:todo_list/detail_todo_page.dart';
import 'package:todo_list/home_page.dart';
// import 'package:todo_list/home_page.dart';
// import 'package:todo_list/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
