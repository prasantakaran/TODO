class Todo {
  String title = '';
  String description = '';
  bool? isCompleted;

  Todo({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    isCompleted = json['isCompleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data['title'] = title;
    _data['description'] = description;
    _data['isCompleted'] = isCompleted;
    return _data;
  }
}
