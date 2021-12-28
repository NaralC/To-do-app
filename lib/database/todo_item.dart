class ToDoItem {
  static String table = 'todo';

  final int id;
  final String name;

  ToDoItem({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ToDoItem.fromMap(Map<String, dynamic> map) {
    return ToDoItem(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }
}
