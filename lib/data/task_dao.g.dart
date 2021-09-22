// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dao.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$TaskDaoMixin on DatabaseAccessor<AppDatabase> {
  $TasksTable get tasks => attachedDatabase.tasks;
  Selectable<Task> completedTaskGenerated() {
    return customSelect(
        'SELECT * FROM tasks WHERE completed = 1 ORDER BY due_data DESC, name;',
        variables: [],
        readsFrom: {
          tasks,
        }).map(tasks.mapFromRow);
  }
}
