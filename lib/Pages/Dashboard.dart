// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Pages/Addtodo.dart';

import '../ModelClass/Todos.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  @override
  void initState() {
    super.initState();
    _getAllTodos();
  }

  _getAllTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todosString = prefs.getString('todos');
    if (todosString != null) {
      List<dynamic> todosJson = json.decode(todosString);
      setState(() {
        todos = todosJson.map((json) => Todo.fromJson(json)).toList();
      });
    }
  }

  _saveTodosLocally() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String todosItem = json.encode(todos.map((todo) => todo.toJson()).toList());
    sp.setString('todos', todosItem);
  }

  _addTodo() async {
    Todo? newTodo = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddTodo()),
    );
    if (newTodo != null) {
      setState(() {
        todos.add(newTodo);
        _saveTodosLocally();
      });
    }
  }

  _editTodo(int index) async {
    Todo? updatedTodo = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTodo(todo: todos[index]),
      ),
    );
    if (updatedTodo != null) {
      setState(() {
        todos[index] = updatedTodo;
        _saveTodosLocally();
      });
    }
  }

  _deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
      _saveTodosLocally();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 28, 143, 165),
        title: const Text(
          'List of TODOs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: todos.isNotEmpty
          ? ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                Todo todo = todos[index];
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10, left: 10),
                      child: ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          todo.description,
                          style: TextStyle(fontSize: 15),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: todo.isCompleted,
                              onChanged: (bool? value) {
                                setState(() {
                                  todo.isCompleted = value!;
                                  _saveTodosLocally();
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => _editTodo(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteTodo(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            )
          : Center(
              child: Text('There are currently no TODO items available.'),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 28, 143, 165),
        onPressed: _addTodo,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add TODO',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
