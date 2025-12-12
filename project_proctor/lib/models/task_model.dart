import 'package:flutter/material.dart';

class Task {
  final String id;
  final String name;
  final String trade;
  final String status; // 'completed', 'in progress', 'not started'
  final String priority; // 'High', 'Urgent', 'Medium', 'Low'
  final int progress; // 0-100
  final String startDate;
  final String endDate;
  final String? assignedTo; // User ID or name
  final String? assignedToName; // Display name

  Task({
    required this.id,
    required this.name,
    required this.trade,
    required this.status,
    required this.priority,
    required this.progress,
    required this.startDate,
    required this.endDate,
    this.assignedTo,
    this.assignedToName,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      trade: json['trade'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      progress: json['progress'] ?? 0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      assignedTo: json['assignedTo']?.toString(),
      assignedToName: json['assignedToName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trade': trade,
      'status': status,
      'priority': priority,
      'progress': progress,
      'startDate': startDate,
      'endDate': endDate,
      'assignedTo': assignedTo,
      'assignedToName': assignedToName,
    };
  }

  Map<String, dynamic> getBadgeColors() {
    Color tradeColor;
    Color tradeTextColor;
    switch (trade.toLowerCase()) {
      case 'concrete':
        tradeColor = const Color(0xFFF5F5F4); // stone-100
        tradeTextColor = const Color(0xFF44403B);
        break;
      case 'steel':
        tradeColor = const Color(0xFFF1F5F9); // slate-100
        tradeTextColor = const Color(0xFF314158);
        break;
      case 'electrical':
        tradeColor = const Color(0xFFFEF9C2); // yellow-100
        tradeTextColor = const Color(0xFFA65F00);
        break;
      case 'hvac':
        tradeColor = const Color(0xFFDFF2FE); // cyan-100
        tradeTextColor = const Color(0xFF0069A8);
        break;
      case 'plumbing':
        tradeColor = const Color(0xFFCEFAFE); // teal-100
        tradeTextColor = const Color(0xFF007595);
        break;
      case 'framing':
        tradeColor = const Color(0xFFFFEDD4); // orange-100
        tradeTextColor = const Color(0xFFCA3500);
        break;
      case 'finishes':
        tradeColor = const Color(0xFFF3E8FF); // purple-100
        tradeTextColor = const Color(0xFF8200DB);
        break;
      default:
        tradeColor = Colors.grey.shade100;
        tradeTextColor = Colors.grey.shade700;
    }

    Color statusColor;
    Color statusBorderColor;
    Color statusTextColor;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = const Color(0xFFD1FAE5); // green-100
        statusBorderColor = const Color(0xFFB9F8CF);
        statusTextColor = const Color(0xFF008236);
        break;
      case 'in progress':
        statusColor = const Color(0xFFDBEAFE); // blue-100
        statusBorderColor = const Color(0xFFBEDBFF);
        statusTextColor = const Color(0xFF1447E6);
        break;
      case 'not started':
        statusColor = const Color(0xFFF3F4F6); // gray-100
        statusBorderColor = const Color(0xFFE5E7EB); // gray-200
        statusTextColor = const Color(0xFF364153);
        break;
      default:
        statusColor = Colors.grey.shade100;
        statusBorderColor = Colors.grey.shade200;
        statusTextColor = Colors.grey.shade700;
    }

    Color priorityColor;
    Color priorityBorderColor;
    Color priorityTextColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = const Color(0xFFFFEDD4); // orange-100
        priorityBorderColor = const Color(0xFFFFD6A7);
        priorityTextColor = const Color(0xFFCA3500);
        break;
      case 'urgent':
        priorityColor = const Color(0xFFFFE2E2); // red-100
        priorityBorderColor = const Color(0xFFFFC9C9);
        priorityTextColor = const Color(0xFFC10007);
        break;
      case 'medium':
        priorityColor = const Color(0xFFDBEAFE); // blue-100
        priorityBorderColor = const Color(0xFFBEDBFF);
        priorityTextColor = const Color(0xFF1447E6);
        break;
      case 'low':
        priorityColor = const Color(0xFFF3F4F6); // gray-100
        priorityBorderColor = const Color(0xFFE5E7EB); // gray-200
        priorityTextColor = const Color(0xFF364153);
        break;
      default:
        priorityColor = Colors.grey.shade100;
        priorityBorderColor = Colors.grey.shade200;
        priorityTextColor = Colors.grey.shade700;
    }

    return {
      'tradeColor': tradeColor.value,
      'tradeTextColor': tradeTextColor.value,
      'statusColor': statusColor.value,
      'statusBorderColor': statusBorderColor.value,
      'statusTextColor': statusTextColor.value,
      'priorityColor': priorityColor.value,
      'priorityBorderColor': priorityBorderColor.value,
      'priorityTextColor': priorityTextColor.value,
    };
  }
}




