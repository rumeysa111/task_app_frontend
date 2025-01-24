import 'dart:convert';

import 'package:task_app/core/constans/constans.dart';
import 'package:http/http.dart' as http;
import 'package:task_app/core/constans/utils.dart';
import 'package:task_app/features/home/repository/task_local_repository.dart';
import 'package:task_app/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TaskRemoteRepository {
  final taskLocalRepository = TaskLocalRepository();
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      // Debugging: Gönderilen verileri konsola yazdır

      // HTTP POST isteği
      final res = await http.post(
        Uri.parse("${Constans.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'hexColor': hexColor, // Format düzeltildi
          'dueAt': dueAt.toIso8601String(),
        }),
      );

      // Debugging: Sunucu yanıtını konsola yazdır

      if (res.statusCode != 201) {
        // Eğer hata varsa, hata mesajını yakala ve yazdır
        final error = jsonDecode(res.body)['error'];
        print("DEBUG: Hata Mesajı: $error");
        throw error;
      }

      // TaskModel oluştur ve geri döndür
      if (res.body.isEmpty || res.body == '{}') {
        throw Exception('Empty or invalid response from server');
      }
      return TaskModel.fromJson(res.body);
    } catch (e) {
      try {
        final taskModel = TaskModel(
            id: const Uuid().v4(),
            uid: uid,
            title: title,
            description: description,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            dueAt: dueAt,
            color: hexToRgb(hexColor),
            isSynced: 0);
        await taskLocalRepository.instertTask(taskModel);
        return taskModel;
      } catch (e) {
        rethrow;
      }
      // Debugging: Hata durumunda hatayı konsola yazdır
    }
  }

  Future<List<TaskModel>> getTasks({required String token}) async {
    try {
      final res = await http.get(
        Uri.parse("${Constans.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }
      final listOfTasks = jsonDecode(res.body);
      List<TaskModel> taskList = [];
      for (var elem in listOfTasks) {
        //print(elem);
        taskList.add(TaskModel.fromMap(elem));
      }
      await taskLocalRepository.insertTasks(taskList);

      return taskList;
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();
      if (tasks.isNotEmpty) {
        return tasks;
      }
      rethrow;
    }
  }

  Future<bool> syncTasks({
    required String token,
    required List<TaskModel> tasks,
  }) async {
    try {
      final taskListInMap = [];
      for (final task in tasks) {
        taskListInMap.add(task.toMap());
      }

      // HTTP POST isteği
      final res = await http.post(
        Uri.parse("${Constans.backendUri}/tasks/sync"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode({taskListInMap}),
      );

      // Debugging: Sunucu yanıtını konsola yazdır

      if (res.statusCode != 201) {
        // Eğer hata varsa, hata mesajını yakala ve yazdır
        throw jsonDecode(res.body)['error'];
      }
      return true;
    } catch (e) {
      print(e);
      return false;
      // Debugging: Hata durumunda hatayı konsola yazdır
    }
  }
}
