import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/loading.dart';
import 'package:todo_app/todo_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(snapshot.error.toString())),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const TodoList(),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.pink,
          ),
        );
      },
    );
  }
}
