import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_app_moor/data/app_database.dart';
import 'package:flutter_app_moor/data/task_dao.dart';
import 'package:flutter_app_moor/home_page.dart';
import 'package:moor/ffi.dart';
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart';
import 'package:sqlite3/open.dart';
// import 'package:sqlite3/sqlite3.dart';

void main() {
  runApp(MyApp(db: _createMoorIsolateAndConnect()));

  // db.dispose();
}

DynamicLibrary _openOnLinux() {
  final scriptDir = File(Platform.script.toFilePath()).parent;
  final libraryNextToScript = File('${scriptDir.path}/sqlite3.so');
  return DynamicLibrary.open(libraryNextToScript.path);
}

DatabaseConnection _createMoorIsolateAndConnect() => DatabaseConnection.delayed(() async {
      final isolate = await _createMoorIsolate();
      return isolate.connect();
    }());

Future<MoorIsolate> _createMoorIsolate() async {
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(sendMoorIsolate: receivePort.sendPort, targetPath: 'db.sqlite'),
  );

  return await receivePort.first as MoorIsolate;
}

void _startBackground(_IsolateStartRequest request) {
  open.overrideFor(OperatingSystem.linux, _openOnLinux);

  final executor = VmDatabase(File(request.targetPath), logStatements: true);

  final moorIsolate = MoorIsolate.inCurrent(() => DatabaseConnection.fromExecutor(executor));

  request.sendMoorIsolate.send(moorIsolate);
}

class _IsolateStartRequest {
  _IsolateStartRequest({required this.sendMoorIsolate, required this.targetPath});

  final SendPort sendMoorIsolate;
  final String targetPath;
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, required DatabaseConnection db})
      : taskDao = AppDatabase.connect(db).taskDao,
        super(key: key);

  final TaskDao taskDao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(taskDao: taskDao),
    );
  }
}
