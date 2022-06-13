import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './task_tile.dart';
import '../models/task.dart';
import '../models/task_data.dart';

class TasksList extends StatefulWidget {
  const TasksList({Key? key}) : super(key: key);

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  Future<void> _showDialog(TaskData taskData, Task item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Platform.isIOS
            ? _cupertinoAlertDialog(taskData, item)
            : _alertDialog(taskData, item);
      },
    );
  }

  Widget _cupertinoAlertDialog(TaskData taskData, Task item) {
    return CupertinoAlertDialog(
      title: const Text(
        'Delete',
        style: TextStyle(
          color: Colors.red,
        ),
      ),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        CupertinoDialogAction(
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            taskData.deleteTask(item);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _alertDialog(TaskData taskData, Task item) {
    return AlertDialog(
      title: const Text(
        'Delete',
        style: TextStyle(color: Colors.red),
      ),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          child: const Text(
            'Yes',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () {
            taskData.deleteTask(item);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final taskItem = taskData.tasks[index];
            return TaskTile(
              taskItem.isDone,
              taskItem.name,
              (bool checkboxState) {
                taskData.updateTask(taskItem);
              },
              () {
                _showDialog(taskData, taskItem);
              },
            );
          },
          itemCount: taskData.taskCount,
        );
      },
    );
  }
}
