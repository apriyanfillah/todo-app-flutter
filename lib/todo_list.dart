import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/loading.dart';
import 'package:todo_app/services/database_services.dart';

import 'models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool isComplet = false;
  TextEditingController todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
          stream: DatabaseService().listTodos(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            // ignore: unused_local_variable
            List<Todo>? todos = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Todos",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black26,
                    ),
                    shrinkWrap: true,
                    itemCount: todos!.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(todos[index].title),
                        background: Container(
                          padding: const EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          color: Colors.red,
                          child: const Icon(Icons.delete),
                        ),
                        onDismissed: (direction) async {
                          await DatabaseService().removeTodo(todos[index].uid);
                        },
                        child: ListTile(
                          onTap: () {
                            DatabaseService().completTask(todos[index].uid);
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(2),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: todos[index].isComplet
                                ? Icon(
                                    Icons.check,
                                    color: Colors.grey[200],
                                    size: 22,
                                  )
                                : Container(),
                          ),
                          title: Text(
                            todos[index].title,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Text(
                    "Add Todo",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.black38,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              children: [
                const Divider(),
                TextFormField(
                  controller: todoTitleController,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.black,
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "eg. exercise",
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () async {
                      if (todoTitleController.text.isNotEmpty) {
                        await DatabaseService()
                            .createNewTodo(todoTitleController.text.trim());
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Add",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            context: context,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
