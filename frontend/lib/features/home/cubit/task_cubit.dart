import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/constans/utils.dart';
import 'package:task_app/features/home/repository/task_local_repository.dart';
import 'package:task_app/features/home/repository/task_remote_repository.dart';
import 'package:task_app/models/task_model.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TasksState> {
  TaskCubit() : super(TasksInitial());
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRespository = TaskLocalRepository();
  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
          uid: uid,
          title: title,
          description: description,
          hexColor: rgbToHex(color),
          token: token,
          dueAt: dueAt);
      await taskLocalRespository.instertTask(taskModel);
      emit(AddNewTaskSuccess(taskModel));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> getAllTasks({
    required String token,
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(
        token: token,
      );
      emit(GetTasksSuccess(tasks));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> syncTasks(String token) async {
    //get all unsynced task from outr database  sqliete db
    final unsyncedTasks = await taskLocalRespository.getUnsycnedTasks();
    if (unsyncedTasks.isNotEmpty) {
      return;
    }
    print(unsyncedTasks);

    // talk to our postresql db to add the new task
    final isSynced = await taskRemoteRepository.syncTasks(
        token: token, tasks: unsyncedTasks);
    // change the tasks that were added to the db from 0 to 1
    if (isSynced) {
      print("sync done");
      for (final task in unsyncedTasks) {
        taskLocalRespository.updateRowValue(task.id, 1);
      }
    }
  }
}
