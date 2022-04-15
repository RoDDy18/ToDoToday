class Task {
  final int? id;
  final String task;
  final DateTime dateTime;
  final String initText;
  Task({this.id, required this.task, required this.dateTime, required this.initText});

  Map<String, dynamic> toMap() {
    return ({'id': id, 'task': task, 'creationDate': dateTime.toString(),'init':initText});
  }
}
