class ToDoItem {
  static String table = 'todo';

  final int? id;
  final String name;

  ToDoItem({
    this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  static ToDoItem fromMap(Map<String, dynamic> map) {
    return ToDoItem(
      id: map['id'],
      name: map['name'],
    );
  }
}
