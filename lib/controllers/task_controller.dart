import 'package:get/get.dart';
import 'package:to_do_list/db/db_helper.dart';
import 'package:to_do_list/models/task.dart';

class TaskController extends GetxController {
  final tasklist = <Task>[].obs;

  Future addTask({required Task task}) {
    return DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    tasklist.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void delettask(Task task) async {
    await DBHelper.delet(task);
    getTasks();
  }

  void deletall() async {
    await DBHelper.deletall();
    getTasks();
  }

  void markascompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
