import 'task_model.dart';

class Project {
  final String id;
  final String name;
  final String manager;
  final String managerId;
  final int progress;
  final String totalBudget;
  final String costToDate;
  final String remaining;
  final int changeOrders;
  final String startDate;
  final String endDate;
  final List<Map<String, dynamic>>? recentActivity;
  final List<Task>? tasks; // List of tasks associated with the project

  Project({
    required this.id,
    required this.name,
    required this.manager,
    required this.managerId,
    required this.progress,
    required this.totalBudget,
    required this.costToDate,
    required this.remaining,
    required this.changeOrders,
    required this.startDate,
    required this.endDate,
    this.recentActivity,
    this.tasks,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    var tasksFromJson = json['tasks'] as List?;
    List<Task> taskList = tasksFromJson != null
        ? tasksFromJson.map((i) => Task.fromJson(i)).toList()
        : [];

    return Project(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      manager: json['manager'] ?? '',
      managerId: json['managerId']?.toString() ?? '',
      progress: json['progress'] ?? 0,
      totalBudget: json['totalBudget'] ?? '',
      costToDate: json['costToDate'] ?? '',
      remaining: json['remaining'] ?? '',
      changeOrders: json['changeOrders'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      recentActivity: (json['recentActivity'] as List?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      tasks: taskList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'manager': manager,
      'managerId': managerId,
      'progress': progress,
      'totalBudget': totalBudget,
      'costToDate': costToDate,
      'remaining': remaining,
      'changeOrders': changeOrders,
      'startDate': startDate,
      'endDate': endDate,
      'recentActivity': recentActivity,
      'tasks': tasks?.map((e) => e.toJson()).toList(),
    };
  }
}




