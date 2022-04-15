// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'db/db_provider.dart';
import 'model/task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
      ),
      home: const MyTodoApp(),
    );
  }
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  State<MyTodoApp> createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color mainColor = const Color(0xFF30303B);
  Color secondColor = const Color(0xFF3E3E47);
  Color buttonColor = const Color(0xFFF44336);
  Color editorColor = const Color(0xFF292936);

  TextEditingController inputTask = TextEditingController();
  String? testText;
  String newTaskTxt = "";

  getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    return tasks;
  }

  deleteTasks() async {
    final tasks = await DBProvider.dataBase.deleteData("tasks");
    return tasks;
  }

  deleteRows(String idtask) async {
    final tasks = await DBProvider.dataBase.deleteRow("tasks", idtask);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CircleAvatar(
            backgroundColor: Color(0xFF30303B),
            backgroundImage: AssetImage("assets/todo.png")),
        elevation: 0.0,
        backgroundColor: mainColor,
        title: const Text("TO-DO Today"),
      ),
      backgroundColor: mainColor,
      body: Column(children: [
        Expanded(
          child: FutureBuilder(
              future: getTasks(),
              builder: (_, AsyncSnapshot taskData) {
                switch (taskData.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  case ConnectionState.done:
                    {
                      if (taskData.data != Null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: taskData.data!.length,
                            itemBuilder: (context, index) {
                              String task = (taskData.data as dynamic)[index]
                                      ['task']
                                  .toString();
                              String day = DateTime.parse((taskData.data
                                      as dynamic)[index]['creationDate'])
                                  .day
                                  .toString();

                              return Card(
                                child: InkWell(
                                  child: Row(children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 12.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                            color: buttonColor,
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Text(day,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(task,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold)),
                                    )),
                                    IconButton(
                                        onPressed: () {
                                          deleteRows(task);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.delete,
                                            color: buttonColor))
                                  ]),
                                ),
                                color: secondColor,
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                            child: Text("You have no tasks today",
                                style: TextStyle(color: Colors.white54)));
                      }
                    }
                  case ConnectionState.none:
                    {
                      return Container();
                    }
                  case ConnectionState.active:
                    {
                      return Container();
                    }
                  default:
                    {
                      return Container();
                    }
                }
              }),
        ),
        //IconButton(onPressed: (){}, icon: const Icon(Icons.delete),color: buttonColor),
        FlatButton.icon(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () {
            deleteTasks();
            setState(() {});
          },
          label: const Text("Clear Tasks"),
          color: buttonColor,
          shape: const StadiumBorder(),
          textColor: Colors.white,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          decoration: BoxDecoration(
              color: editorColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                      controller: inputTask,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Enter a new task",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ))),
              const SizedBox(
                width: 15.0,
              ),
              FlatButton.icon(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  setState(() {
                    newTaskTxt = inputTask.text.toString();
                    inputTask.text = "";
                  });
                  Task newTask = Task(
                      task: newTaskTxt,
                      dateTime: DateTime.now(),
                      initText: "init");
                  if (newTaskTxt != "") {
                    DBProvider.dataBase.addNewTask(newTask);
                    testText = newTask.task;
                  }
                },
                label: const Text("Add Task"),
                color: buttonColor,
                shape: const StadiumBorder(),
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
