import '../models/project_model.dart';
import '../models/task_model.dart';

/// Service class for managing project data
/// This can be easily replaced with API calls when backend is ready
abstract class ProjectService {
  Future<Project> getProject(String projectId);
  Future<List<Task>> getProjectTasks(String projectId);
  Future<Task> createTask(String projectId, Task task);
  Future<Task> updateTask(String taskId, Task task);
  Future<void> deleteTask(String taskId);
}

/// Mock implementation - replace this with API implementation later
class MockProjectService implements ProjectService {
  // In-memory store for mock data
  static final Map<String, Project> _projects = {
    'default': Project(
      id: 'default',
      name: 'Riverside Office Complex',
      manager: 'Sarah Johnson',
      managerId: 'manager_001',
      progress: 68,
      totalBudget: '\$2.50M',
      costToDate: '\$1.70M',
      remaining: '\$0.80M',
      changeOrders: 5,
      startDate: 'Sep 15, 2024',
      endDate: 'Jun 30, 2025',
      recentActivity: [
        {
          'title': 'Electrical Rough-In updated to 65%',
          'author': 'Mike Chen',
          'time': '2 hours ago',
        },
        {
          'title': 'Added 5 new photos to gallery',
          'author': 'Sarah Johnson',
          'time': '5 hours ago',
        },
        {
          'title': 'Change Order #CO-012 approved',
          'author': 'Emily Rodriguez',
          'time': '1 day ago',
        },
        {
          'title': 'HVAC Installation started',
          'author': 'David Kim',
          'time': '2 days ago',
        },
      ],
      tasks: [
        Task(
          id: 'task_001',
          name: 'Foundation Work',
          trade: 'Concrete',
          status: 'completed',
          priority: 'High',
          progress: 100,
          startDate: 'Sep 15',
          endDate: 'Oct 15',
          assignedTo: 'user_001',
          assignedToName: 'Maria Garcia',
        ),
        Task(
          id: 'task_002',
          name: 'Structural Steel',
          trade: 'Steel',
          status: 'completed',
          priority: 'High',
          progress: 100,
          startDate: 'Oct 20',
          endDate: 'Nov 30',
          assignedTo: 'user_001',
          assignedToName: 'Maria Garcia',
        ),
        Task(
          id: 'task_003',
          name: 'Electrical Rough-In',
          trade: 'Electrical',
          status: 'in progress',
          priority: 'Urgent',
          progress: 65,
          startDate: 'Nov 15',
          endDate: 'Dec 31',
          assignedTo: 'user_002',
          assignedToName: 'John Martinez',
        ),
        Task(
          id: 'task_004',
          name: 'HVAC Installation',
          trade: 'HVAC',
          status: 'in progress',
          priority: 'Medium',
          progress: 45,
          startDate: 'Nov 20',
          endDate: 'Jan 15',
          assignedTo: 'user_003',
          assignedToName: 'Robert Johnson',
        ),
        Task(
          id: 'task_005',
          name: 'Plumbing Rough-In',
          trade: 'Plumbing',
          status: 'in progress',
          priority: 'High',
          progress: 38,
          startDate: 'Nov 25',
          endDate: 'Dec 28',
          assignedTo: 'user_004',
          assignedToName: 'Lisa Chen',
        ),
        Task(
          id: 'task_006',
          name: 'Drywall Installation',
          trade: 'Framing',
          status: 'not started',
          priority: 'Medium',
          progress: 0,
          startDate: 'Jan 5',
          endDate: 'Feb 15',
          assignedTo: null,
          assignedToName: null,
        ),
        Task(
          id: 'task_007',
          name: 'Interior Finishes',
          trade: 'Finishes',
          status: 'not started',
          priority: 'Low',
          progress: 0,
          startDate: 'Feb 20',
          endDate: 'Apr 30',
          assignedTo: null,
          assignedToName: null,
        ),
      ],
    ),
  };

  @override
  Future<Project> getProject(String projectId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _projects[projectId] ?? _projects['default']!;
  }

  @override
  Future<List<Task>> getProjectTasks(String projectId) async {
    await Future.delayed(Duration(milliseconds: 300));
    return _projects[projectId]?.tasks ?? _projects['default']?.tasks ?? [];
  }

  @override
  Future<Task> createTask(String projectId, Task task) async {
    await Future.delayed(Duration(milliseconds: 300));
    final project = _projects[projectId] ?? _projects['default'];
    if (project != null) {
      final newTask = Task(
        id: 'task_${(project.tasks?.length ?? 0) + 1}',
        name: task.name,
        trade: task.trade,
        status: task.status,
        priority: task.priority,
        progress: task.progress,
        startDate: task.startDate,
        endDate: task.endDate,
        assignedTo: task.assignedTo,
        assignedToName: task.assignedToName,
      );
      // Create a new list with the new task added
      final updatedTasks = List<Task>.from(project.tasks ?? [])..add(newTask);
      // Update the project with new tasks list
      _projects[projectId] = Project(
        id: project.id,
        name: project.name,
        manager: project.manager,
        managerId: project.managerId,
        progress: project.progress,
        totalBudget: project.totalBudget,
        costToDate: project.costToDate,
        remaining: project.remaining,
        changeOrders: project.changeOrders,
        startDate: project.startDate,
        endDate: project.endDate,
        recentActivity: project.recentActivity,
        tasks: updatedTasks,
      );
      return newTask;
    }
    throw Exception('Project not found');
  }

  @override
  Future<Task> updateTask(String taskId, Task updatedTask) async {
    await Future.delayed(Duration(milliseconds: 300));
    for (var entry in _projects.entries) {
      final project = entry.value;
      final index = project.tasks?.indexWhere((task) => task.id == taskId);
      if (index != null && index != -1) {
        // Create a new list with the updated task
        final updatedTasks = List<Task>.from(project.tasks ?? []);
        updatedTasks[index] = updatedTask;
        // Update the project with new tasks list
        _projects[entry.key] = Project(
          id: project.id,
          name: project.name,
          manager: project.manager,
          managerId: project.managerId,
          progress: project.progress,
          totalBudget: project.totalBudget,
          costToDate: project.costToDate,
          remaining: project.remaining,
          changeOrders: project.changeOrders,
          startDate: project.startDate,
          endDate: project.endDate,
          recentActivity: project.recentActivity,
          tasks: updatedTasks,
        );
        return updatedTask;
      }
    }
    throw Exception('Task not found');
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await Future.delayed(Duration(milliseconds: 300));
    for (var entry in _projects.entries) {
      final project = entry.value;
      if (project.tasks != null && project.tasks!.any((task) => task.id == taskId)) {
        // Create a new list without the deleted task
        final updatedTasks = project.tasks!.where((task) => task.id != taskId).toList();
        // Update the project with new tasks list
        _projects[entry.key] = Project(
          id: project.id,
          name: project.name,
          manager: project.manager,
          managerId: project.managerId,
          progress: project.progress,
          totalBudget: project.totalBudget,
          costToDate: project.costToDate,
          remaining: project.remaining,
          changeOrders: project.changeOrders,
          startDate: project.startDate,
          endDate: project.endDate,
          recentActivity: project.recentActivity,
          tasks: updatedTasks,
        );
      }
    }
  }
}

