import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../ModelClass/Todos.dart';

class AddTodo extends StatefulWidget {
  final Todo? todo;

  AddTodo({this.todo});

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    if (widget.todo != null) {
      _isCompleted = widget.todo!.isCompleted!;
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(Todo(
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: _isCompleted,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 28, 143, 165),
        title: Text(
          widget.todo == null ? 'Add TODO' : 'Edit TODO',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                    labelText: 'Title',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  _titleController.text = value;
                }),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    labelText: 'Description',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {
                  _descriptionController.text = value;
                }),
              ),
              SizedBox(height: 5),
              _titleController.text.isNotEmpty ||
                      _descriptionController.text.isNotEmpty
                  ? SwitchListTile(
                      title: Text('Completed'),
                      value: _isCompleted,
                      onChanged: (bool value) {
                        setState(() {
                          _isCompleted = value;
                        });
                      },
                    )
                  : SizedBox(),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 28, 143, 165),
                  ),
                  onPressed: _submit,
                  label: Text(
                    widget.todo == null ? 'Save' : 'Update',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  icon: Icon(
                    color: Colors.white,
                    widget.todo == null ? Icons.save_outlined : Icons.update,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
