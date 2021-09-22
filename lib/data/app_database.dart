import 'dart:io';

import 'package:flutter_app_moor/data/task_dao.dart';
import 'package:flutter_app_moor/data/tasks.dart';
import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';

part 'app_database.g.dart';


LazyDatabase _openConnection() {
  return LazyDatabase(() => VmDatabase(File('db.sqlite'), logStatements: true));
}

@UseMoor(tables: [Tasks], daos: [TaskDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.connect(DatabaseConnection connection) : super.connect(connection);

  @override
  int get schemaVersion => 1;
}
