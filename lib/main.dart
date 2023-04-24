import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ToDo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> taskList = [];

  final newTaskController = TextEditingController();

  void addTask(context) {
    bool taskAlreadyExists =
        taskList.any((item) => item.name.contains(newTaskController.text));
    if (!taskAlreadyExists) {
      setState(() {
        taskList.add(Task(newTaskController.text, taskList.length, false));
        sortTasks();
      });
      newTaskController.clear();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro!'),
          content: const Text('Essa task já foi criada anteriormente'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void markTasksAsChecked(int index) {
    setState(() {
      taskList[index].isCompleted = !taskList[index].isCompleted;
      sortTasks();
    });
  }

  void removeTask(int index) {
    setState(() {
      taskList.removeAt(index);
      sortTasks();
    });
  }

  void sortTasks() {
    if (taskList.isNotEmpty) {
      taskList.sort((taskA, taskB) =>
          taskA.name.toLowerCase().compareTo(taskB.name.toLowerCase()));
      taskList.sort((taskA, taskB) => (taskA.isCompleted == taskB.isCompleted)
          ? 0
          : (taskA.isCompleted ? 1 : -1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            TextField(
              onSubmitted: (string) => addTask(context),
              controller: newTaskController,
              decoration: const InputDecoration(hintText: "Create a new task"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final task = taskList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.name,
                                  style: task.isCompleted
                                      ? const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough)
                                      : const TextStyle()),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => markTasksAsChecked(index),
                                icon: task.isCompleted
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.green)
                                    : const Icon(Icons.check_circle_outline,
                                        color: Colors.grey),
                              ),
                              IconButton(
                                onPressed: () => {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('DELETAR!'),
                                        content: const Text(
                                            'Tem certeza que deseja deletar essa task?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text('NÃO'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              removeTask(
                                                  index); // Close the dialog
                                            },
                                            child: const Text('SIM'),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}

class Task {
  String name = "";
  int id = 0;
  bool isCompleted = false;

  Task(this.name, this.id, this.isCompleted);
}
