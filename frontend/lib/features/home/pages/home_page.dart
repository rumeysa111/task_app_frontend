import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constans/utils.dart';
import 'package:task_app/features/auth/cubit/auth_cubit.dart';
import 'package:task_app/features/home/cubit/task_cubit.dart';
import 'package:task_app/features/home/pages/add_new_task_page.dart';
import 'package:task_app/features/home/widgets/date_selector.dart';
import 'package:task_app/features/home/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TaskCubit>().getAllTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)) {
        await context.read<TaskCubit>().syncTasks(user.user.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Tasks"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, AddNewTaskPage.route());
              },
              icon: const Icon(
                CupertinoIcons.add,
              ))
        ],
      ),
      body: BlocBuilder<TaskCubit, TasksState>(builder: (context, state) {
        if (state is TasksLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is TasksError) {
          return Center(
            child: Text(state.error),
          );
        }
        if (state is GetTasksSuccess) {
          final tasks = state.tasks
              .where((elem) =>
                  DateFormat('d').format(elem.dueAt) ==
                      DateFormat("d").format(selectedDate) &&
                  selectedDate.month == elem.dueAt.month &&
                  selectedDate.year == elem.dueAt.year)
              .toList();
          return Column(
            children: [
              //date selector
              DateSelector(
                selectedDate: selectedDate,
                onTap: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),

              Expanded(
                child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Row(
                        children: [
                          Expanded(
                            child: TaskCard(
                                color: task.color,
                                headerText: task.title,
                                descriptionText: task.description),
                          ),
                          Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: strengthenColor(task.color, 0.69),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              DateFormat.jm().format(task.dueAt),
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              )
            ],
          );
        }
        return const SizedBox();
      }),
    );
  }
}
