import 'package:flutter_app_moor/data/app_database.dart';
import 'package:flutter_app_moor/data/tasks.dart';
import 'package:moor/moor.dart';

part 'task_dao.g.dart';

@UseDao(
  tables: [Tasks],
  queries: {'completedTaskGenerated': 'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_data DESC, name;'},
)
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTasks() => select(tasks).get();

  Stream<List<Task>> watchAllTasks() {
    return (select(tasks)
          ..orderBy([
            (t) => OrderingTerm.desc(t.dueData),
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)
          ..orderBy([
            (t) => OrderingTerm.desc(t.dueData),
            (t) => OrderingTerm(expression: t.name),
          ])
          ..where((tbl) => tbl.completed.equals(true)))
        .watch();
  }

  Stream<List<Task>> watchCompletedTasksCustom() {
    return customSelect('SELECT * FROM tasks WHERE completed = 1 ORDER BY due_data DESC, name;', readsFrom: {tasks})
        .map((rows) => Task.fromData(rows.data, db))
        .watch();
  }

  Future<int> insertTask(Task task) => into(tasks).insert(TasksCompanion.insert(name: task.name));

  Future<bool> updateTask(Insertable<Task> task) => update(tasks).replace(task);

  Future<int> deleteTask(Insertable<Task> task) => delete(tasks).delete(task);

  Future<int> saveTask(Insertable<Task> task) => into(tasks).insertOnConflictUpdate(task);

  final AppDatabase db;
}
