import 'package:flutter/material.dart';
import 'package:flutter_app_moor/data/app_database.dart';
import 'package:flutter_app_moor/data/task_dao.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.taskDao}) : super(key: key);

  final TaskDao taskDao;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                final task = Task(id: 1, name: 'name', completed: false);
                final result = await taskDao.insertTask(task);
                debugPrint(result.toString());
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () async {
                final task = Task(id: 1, name: 'name1', completed: false);
                final result = await taskDao.updateTask(task);
                debugPrint(result.toString());
              },
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () async {
                final task = Task(id: 2, name: 'name2', dueData: DateTime.now(), completed: false);
                final result = await taskDao.saveTask(task);
                debugPrint(result.toString());
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
