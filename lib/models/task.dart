import 'dart:convert';

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'color': color,
      'remind': remind,
      'repeat': repeat,
    };
  }

  Task.fromJson(Map<String, dynamic> jason) {
    id = jason['id'] != null ? jason['id'] as int : null;
    title = jason['title'] != null ? jason['title'] as String : null;
    note = jason['note'] != null ? jason['note'] as String : null;
    isCompleted =
        jason['isCompleted'] != null ? jason['isCompleted'] as int : null;
    date = jason['date'] != null ? jason['date'] as String : null;
    startTime =
        jason['startTime'] != null ? jason['startTime'] as String : null;
    endTime = jason['endTime'] != null ? jason['endTime'] as String : null;
    color = jason['color'] != null ? jason['color'] as int : null;
    remind = jason['remind'] != null ? jason['remind'] as int : null;

    repeat = jason['repeat'] != null ? jason['repeat'] as String : null;
  }
}
