import 'package:flutter/material.dart';
import 'database/db.dart';
import 'database/todo_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> _todo = [];
  List<Widget> get _items => _todo.map((item) => format(item)).toList();
  String _name = '';

  @override
  void initState() {
    refresh();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Text(
                "To-Do",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ListView(
              children: _items,
              shrinkWrap: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () => _create(context),
        child: Icon(Icons.add_circle, color: Colors.white),
      ),
    );
  }

  void _create(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Add Task"),
        content: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: "Task Name"),
                onChanged: (name) {
                  _name = name;
                },
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _save(),
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _save() async {
    Navigator.of(context).pop();
    ToDoItem item = ToDoItem(name: _name);

    await DB.insert(ToDoItem.table, item);
    setState(() => _name = '');
    refresh();
  }

  Future<void> refresh() async {
    List<Map<String, dynamic>> results = await DB.query(ToDoItem.table);
    _todo = results.map((item) => ToDoItem.fromMap(item)).toList();
    setState(() {});
  }

  Widget format(ToDoItem item) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Dismissible(
          onDismissed: (DismissDirection dismiss) {
            DB.delete(ToDoItem.table, item);
            refresh();
          },
          key: Key(item.id.toString()),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  )
                ]),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
