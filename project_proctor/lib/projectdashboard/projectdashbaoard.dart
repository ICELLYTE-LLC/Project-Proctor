import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/bottom_navigation.dart';
import '../Projects/projects.dart';
import '../Add New Member/addnewmember.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../services/project_service.dart';
import '../edit task/edittask.dart';
import '../admin/photos.dart';
import '../admin/subcontractor.dart';
import '../admin/change_order.dart';
import '../admin/settings.dart';
import '../admin/logout_dialog.dart';

// Custom page route with no animation for instant navigation
class _NoAnimationPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  _NoAnimationPageRoute({required this.builder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class ProjectDashboard extends StatefulWidget {
  final Map<String, dynamic> project;

  const ProjectDashboard({
    super.key,
    required this.project,
  });

  @override
  State<ProjectDashboard> createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> with SingleTickerProviderStateMixin {
  int _selectedTab = 0; // 0: Overview, 1: Tasks, 2: Gantt
  AnimationController? _fadeController;
  
  // Service for data management
  final ProjectService _projectService = MockProjectService();
  
  // Data state
  Project? _project;
  List<Task> _tasks = [];
  bool _isLoading = false;
  
  Animation<double> get _fadeAnimation {
    if (_fadeController != null) {
      return CurvedAnimation(
        parent: _fadeController!,
        curve: Curves.easeIn,
      );
    }
    return AlwaysStoppedAnimation(1.0);
  }

  // Color constants matching Figma exactly
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF101828);
  static const Color textGray = Color(0xFF6A7282);
  static const Color textGrayDark = Color(0xFF4A5565);
  static const Color bgGray50 = Color(0xFFF9FAFB);
  static const Color bgGray200 = Color(0xFFE5E7EB);
  static const Color primaryBlue = Color(0xFF2779F5); // rgb(39, 121, 245)
  static const Color primaryBlueDark = Color(0xFF1D63D8); // rgb(29, 99, 216)
  static const Color primaryBlueDarker = Color(0xFF1554BF); // rgb(21, 84, 191)
  static const Color blue100 = Color(0xFFDBEAFE); // Tailwind blue-100, exact match
  // progressBarBg: rgb(28, 57, 142) - used as Color.fromRGBO(28, 57, 142, 0.4)
  static const Color progressGreen1 = Color(0xFF00D492); // rgb(0, 212, 146)
  static const Color progressGreen2 = Color(0xFF05DF72); // rgb(5, 223, 114)
  static const Color progressGreen3 = Color(0xFF46ECD5); // rgb(70, 236, 213)

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController!.forward();
    _initializeWithMockData();
    _loadProjectData();
  }

  void _initializeWithMockData() {
    _isLoading = false;
    _tasks = [
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
    ];
  }

  Future<void> _loadProjectData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final projectId = widget.project['id']?.toString() ?? 'default';
      final project = await _projectService.getProject(projectId);
      final tasks = await _projectService.getProjectTasks(projectId);

      if (mounted) {
        setState(() {
          _project = project;
          _tasks = tasks.isNotEmpty ? tasks : _tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> get projectData {
    if (_project != null) {
      return {
        'id': _project!.id,
        'name': _project!.name,
        'manager': _project!.manager,
        'progress': _project!.progress,
        'totalBudget': _project!.totalBudget,
        'costToDate': _project!.costToDate,
        'remaining': _project!.remaining,
        'changeOrders': _project!.changeOrders,
        'startDate': _project!.startDate,
        'endDate': _project!.endDate,
        'recentActivity': _project!.recentActivity,
      };
    }
    return widget.project;
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final baseWidth = 161.0;
    final scale = (screenWidth / baseWidth).clamp(0.8, 2.0);

    return Scaffold(
      backgroundColor: bgGray50,
      extendBody: true,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 2, // Dashboard is selected
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const ProjectsPage(),
              ),
              (route) => false,
            );
          } else if (index == 1) {
            // Role/AddNewMember - use push to maintain navigation stack
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewMember(),
                maintainState: true,
              ),
            );
          } else if (index == 2) {
            return;
          } else if (index == 3) {
            // Settings - use push to maintain navigation stack
            Navigator.push(
              context,
              _NoAnimationPageRoute(
                builder: (context) => SettingsPage(),
              ),
            ).catchError((error) {
              // Handle any navigation errors gracefully
              print('Navigation error: $error');
            });
          } else if (index == 4) {
            // Logout
            LogoutDialog.show(context);
          }
        },
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bgGray50,
                    white,
                    Color.fromRGBO(239, 246, 255, 0.3),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Column(
                children: [
                  // Header Section
                  _buildHeader(scale),
                  // Overall Progress Card
                  _buildProgressCard(scale),
                  // Navigation Tabs
                  _buildTabs(scale),
                  // Content based on selected tab
                  _buildTabContent(scale),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    final data = projectData;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.061 * scale),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.8),
        border: Border(
          bottom: BorderSide(
            color: bgGray200,
            width: 0.379 * scale,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0.379 * scale),
            blurRadius: 1.136 * scale,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0.379 * scale),
            blurRadius: 0.758 * scale,
            spreadRadius: -0.379 * scale,
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 15.153 * scale,
              height: 15.153 * scale,
              padding: EdgeInsets.all(3.031 * scale),
              child: Icon(
                Icons.arrow_back,
                size: 9.092 * scale,
                color: textDark,
              ),
            ),
          ),
          SizedBox(width: 6.061 * scale),
          // Project Title and Manager
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [textDark, primaryBlue],
                  ).createShader(bounds),
                  child: Text(
                    data['name'] ?? 'Riverside Office Complex',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 6.061 * scale,
                      fontWeight: FontWeight.w400,
                      color: white,
                    ),
                  ),
                ),
                SizedBox(height: 0.76 * scale),
                Text(
                  'Managed by ${data['manager'] ?? 'Sarah Johnson'}',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.061 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray,
                  ),
                ),
              ],
            ),
          ),
          // Share Icon - Made bigger
          GestureDetector(
            onTap: () => _showShareDialog(context, scale),
            child: Container(
              width: 20.0 * scale,
              height: 20.0 * scale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [primaryBlue, primaryBlueDark],
                ),
                borderRadius: BorderRadius.circular(6.0 * scale),
                boxShadow: [
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.3),
                    offset: Offset(0, 4.0 * scale),
                    blurRadius: 6.0 * scale,
                    spreadRadius: -1.0 * scale,
                  ),
                  BoxShadow(
                    color: primaryBlue.withOpacity(0.25),
                    offset: Offset(0, 2.0 * scale),
                    blurRadius: 3.0 * scale,
                    spreadRadius: -1.5 * scale,
                  ),
                ],
              ),
              child: Icon(
                Icons.share,
                size: 10.0 * scale,
                color: white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(double scale) {
    final data = projectData;
    final progress = data['progress'] ?? 68;
    
    return Container(
      margin: EdgeInsets.all(6.061 * scale),
      padding: EdgeInsets.all(9.092 * scale),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryBlue, // #2779F5 rgb(39, 121, 245)
            primaryBlueDark, // #1D63D8 rgb(29, 99, 216)
            primaryBlueDarker, // #1554BF rgb(21, 84, 191)
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(6.061 * scale),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            offset: Offset(0, 9.471 * scale),
            blurRadius: 18.941 * scale,
            spreadRadius: -4.546 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Overall Progress',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.061 * scale,
                  fontWeight: FontWeight.w400,
                  color: blue100,
                ),
              ),
              Text(
                '$progress%',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 11.365 * scale,
                  fontWeight: FontWeight.w400,
                  color: white,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.546 * scale),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: progress / 100.0),
              duration: Duration(milliseconds: 1500),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Container(
                  height: 8.5 * scale, // Increased height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF1C398E), // Dark blue rgb(28, 57, 142) - unfilled area
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      // Filled portion
                      Expanded(
                        flex: (value * 100).round(),
                        child: Container(
                          height: 8.5 * scale, // Increased height
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                progressGreen1, // #00d492 - bright green (left)
                                progressGreen2, // #05df72 - middle green (50%)
                                progressGreen3, // #46ecd5 - turquoise/cyan (right)
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(100), // Fully rounded on all sides
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color.fromRGBO(255, 255, 255, 0.3), // rgba(255,255,255,0.3)
                                  Colors.transparent,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(100), // Fully rounded on all sides
                            ),
                          ),
                        ),
                      ),
                      // Unfilled portion - explicitly visible
                      Expanded(
                        flex: 100 - (value * 100).round(),
                        child: Container(
                          height: 8.5 * scale, // Increased height
                          decoration: BoxDecoration(
                            color: Color(0xFF1C398E), // Dark blue - unfilled area
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 7.576 * scale),
          // Budget Stats Grid
          _buildBudgetGrid(scale),
        ],
      ),
    );
  }

  Widget _buildBudgetGrid(double scale) {
    final data = projectData;
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6, // Reduced to increase card height
      crossAxisSpacing: 4.55 * scale,
      mainAxisSpacing: 4.55 * scale,
      children: [
        _buildBudgetCard(scale, Icons.attach_money, 'Total Budget', data['totalBudget'] ?? '\$2.50M', white),
        _buildBudgetCard(scale, Icons.trending_up, 'Cost to Date', data['costToDate'] ?? '\$1.70M', Color(0xFF4CAF50)), // Green
        _buildBudgetCard(scale, Icons.attach_money, 'Remaining', data['remaining'] ?? '\$0.80M', Color(0xFFFFEB3B)), // Yellow
        _buildBudgetCard(scale, Icons.description_outlined, 'Change Orders', '${data['changeOrders'] ?? 5}', Color(0xFFFF9800)), // Orange
      ],
    );
  }

  Widget _buildBudgetCard(double scale, IconData icon, String label, String value, Color iconColor) {
    return Container(
      padding: EdgeInsets.only(
        top: 8.0 * scale, // Increased padding
        left: 8.0 * scale, // Increased padding
        right: 8.0 * scale, // Increased padding
        bottom: 8.0 * scale, // Increased padding
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.15), // rgba(255, 255, 255, 0.15) - exact Figma match
        border: Border.all(
          color: Color.fromRGBO(255, 255, 255, 0.2), // rgba(255, 255, 255, 0.2) - exact Figma match
          width: 0.379 * scale,
        ),
        borderRadius: BorderRadius.circular(5.308 * scale),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 3.791 * scale),
            blurRadius: 5.687 * scale,
            spreadRadius: -1.137 * scale,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 1.517 * scale),
            blurRadius: 2.275 * scale,
            spreadRadius: -1.517 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon and Label Row - increased sizes
          Row(
            children: [
              Icon(
                icon,
                size: 12.0 * scale, // Significantly increased icon size
                color: iconColor, // Colored icons: white, green, yellow, orange
              ),
              SizedBox(width: 4.0 * scale), // Increased spacing
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 7.0 * scale, // Reduced to fit "Change Orders" in one line
                    fontWeight: FontWeight.w400,
                    color: white, // Labels are white in the image
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.0 * scale), // Increased spacing
          // Value - significantly increased font size
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 12.0 * scale, // Significantly increased font size
              fontWeight: FontWeight.w400,
              color: white, // Values are white
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(double scale) {
    return Container(
      decoration: BoxDecoration(
        color: white,
        border: Border(
          bottom: BorderSide(
            color: bgGray200,
            width: 0.379 * scale,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab(scale, 0, Icons.dashboard_outlined, 'Overview'),
          _buildTab(scale, 1, Icons.task_outlined, 'Tasks'),
          _buildTab(scale, 2, Icons.bar_chart_outlined, 'Gantt'),
        ],
      ),
    );
  }

  Widget _buildTab(double scale, int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          height: 22.0 * scale, // Increased height
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFF0F7FF) : Colors.transparent, // Light blue background for selected
            border: Border(
              top: BorderSide(
                color: isSelected ? primaryBlue : Colors.transparent,
                width: 0.379 * scale,
              ),
              left: BorderSide(
                color: isSelected ? primaryBlue : Colors.transparent,
                width: 0.379 * scale,
              ),
              right: BorderSide(
                color: isSelected ? primaryBlue : Colors.transparent,
                width: 0.379 * scale,
              ),
              bottom: BorderSide(
                color: isSelected ? primaryBlue : Colors.transparent,
                width: 0.758 * scale, // Thicker bottom border for selected
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 7.0 * scale, // Increased icon size
                color: isSelected ? primaryBlue : textDark,
              ),
              SizedBox(width: 3.5 * scale), // Increased spacing
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.5 * scale, // Increased font size
                  fontWeight: FontWeight.w400,
                  color: isSelected ? primaryBlue : textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(double scale) {
    switch (_selectedTab) {
      case 0:
        return _buildOverviewContent(scale);
      case 1:
        return _buildTasksContent(scale);
      case 2:
        return _buildGanttContent(scale);
      default:
        return _buildTasksContent(scale);
    }
  }

  Widget _buildOverviewContent(double scale) {
    final data = projectData;
    
    return Padding(
      padding: EdgeInsets.all(9.092 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Export to PDF Button
          Container(
            width: double.infinity,
            height: 20.0 * scale, // Increased height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF009966), Color(0xFF009689)],
              ),
              borderRadius: BorderRadius.circular(5.308 * scale),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF009966).withOpacity(0.25),
                  offset: Offset(0, 3.791 * scale),
                  blurRadius: 5.687 * scale,
                  spreadRadius: -1.137 * scale,
                ),
                BoxShadow(
                  color: Color(0xFF009966).withOpacity(0.25),
                  offset: Offset(0, 1.517 * scale),
                  blurRadius: 2.275 * scale,
                  spreadRadius: -1.517 * scale,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  size: 7.0 * scale, // Increased icon size
                  color: white,
                ),
                SizedBox(width: 3.0 * scale), // Increased spacing
                Text(
                  'Export to PDF',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.5 * scale, // Increased font size
                    fontWeight: FontWeight.w400,
                    color: white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 9.092 * scale),
          // Date Cards
          Row(
            children: [
              Expanded(child: _buildStartDateCard(scale)),
              SizedBox(width: 6.066 * scale),
              Expanded(child: _buildEndDateCard(scale)),
            ],
          ),
          SizedBox(height: 9.092 * scale),
          // Quick Actions
          Row(
            children: [
              Expanded(child: _buildPhotosButton(scale)),
              SizedBox(width: 6.066 * scale),
              Expanded(child: _buildTeamButton(scale)),
              SizedBox(width: 6.066 * scale),
              Expanded(child: _buildChangesButton(scale)),
            ],
          ),
          SizedBox(height: 9.092 * scale),
          // Recent Activity
          Container(
            padding: EdgeInsets.all(7.962 * scale),
            decoration: BoxDecoration(
              color: white,
              border: Border.all(
                color: bgGray200,
                width: 0.379 * scale,
              ),
              borderRadius: BorderRadius.circular(6.066 * scale),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0.379 * scale),
                  blurRadius: 1.137 * scale,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0.379 * scale),
                  blurRadius: 0.758 * scale,
                  spreadRadius: -0.379 * scale,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.825 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 6.066 * scale),
                ...((data['recentActivity'] as List?) ?? [
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
                ]).map((activity) => _buildActivityItem(scale, activity)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartDateCard(double scale) {
    final data = projectData;
    
    return Container(
      height: 42.0 * scale, // Increased height
      padding: EdgeInsets.all(6.07 * scale),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(
          color: bgGray200,
          width: 0.379 * scale,
        ),
        borderRadius: BorderRadius.circular(6.066 * scale),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0.379 * scale),
            blurRadius: 1.137 * scale,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0.379 * scale),
            blurRadius: 0.758 * scale,
            spreadRadius: -0.379 * scale,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.066 * scale),
        child: Stack(
          clipBehavior: Clip.hardEdge, // Clip shape to card boundaries
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.133 * scale,
                      height: 12.133 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Perfect circle instead of rounded square
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
                        ),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 6.066 * scale,
                        color: white,
                      ),
                    ),
                    SizedBox(width: 3.033 * scale),
                    Expanded(
                      child: Text(
                        'Start Date',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 6.066 * scale,
                          fontWeight: FontWeight.w400,
                          color: textGrayDark,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.033 * scale),
                Text(
                  data['startDate'] ?? 'Sep 15, 2024',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.066 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                  ),
                ),
              ],
            ),
            // Blue decorative shape at very top right corner - only inside part visible
            Positioned(
              right: -15.166 * scale, // Half of circle diameter to make it flush
              top: -15.166 * scale,
              child: Container(
                width: 30.332 * scale,
                height: 30.332 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
                  ),
                ),
                child: Opacity(
                  opacity: 0.69,
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDateCard(double scale) {
    final data = projectData;
    
    return Container(
      height: 42.0 * scale, // Increased height
      padding: EdgeInsets.all(6.07 * scale),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(
          color: bgGray200,
          width: 0.379 * scale,
        ),
        borderRadius: BorderRadius.circular(6.066 * scale),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0.379 * scale),
            blurRadius: 1.137 * scale,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 0.379 * scale),
            blurRadius: 0.758 * scale,
            spreadRadius: -0.379 * scale,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.066 * scale),
        child: Stack(
          clipBehavior: Clip.hardEdge, // Clip shape to card boundaries
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.133 * scale,
                      height: 12.133 * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Perfect circle instead of rounded square
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFFE9A00), Color(0xFFE17100)],
                        ),
                      ),
                      child: Icon(
                        Icons.event,
                        size: 6.066 * scale,
                        color: white,
                      ),
                    ),
                    SizedBox(width: 3.033 * scale),
                    Expanded(
                      child: Text(
                        'End Date',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 6.066 * scale,
                          fontWeight: FontWeight.w400,
                          color: textGrayDark,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.033 * scale),
                Text(
                  data['endDate'] ?? 'Jun 30, 2025',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.066 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                  ),
                ),
              ],
            ),
            // Orange decorative shape at very top right corner - only inside part visible
            Positioned(
              right: -15.166 * scale, // Half of circle diameter to make it flush
              top: -15.166 * scale,
              child: Container(
                width: 30.332 * scale,
                height: 30.332 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFE9A00), Color(0xFFE17100)],
                  ),
                ),
                child: Opacity(
                  opacity: 0.69,
                  child: Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosButton(double scale) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhotosPage()),
        );
      },
      child: Container(
        height: 40.19 * scale,
        padding: EdgeInsets.all(6.07 * scale),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
            color: bgGray200,
            width: 0.379 * scale,
          ),
          borderRadius: BorderRadius.circular(5.308 * scale),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0.379 * scale),
              blurRadius: 1.137 * scale,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0.379 * scale),
              blurRadius: 0.758 * scale,
              spreadRadius: -0.379 * scale,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.166 * scale,
              height: 15.166 * scale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFAD46FF), Color(0xFFF6339A)],
                ),
                borderRadius: BorderRadius.circular(5.308 * scale),
              ),
              child: Icon(
                Icons.photo_library,
                size: 7.583 * scale,
                color: white,
              ),
            ),
            SizedBox(height: 3.038 * scale),
            Text(
              'Photos',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.066 * scale,
                fontWeight: FontWeight.w400,
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamButton(double scale) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => projects()),
        );
      },
      child: Container(
        height: 40.19 * scale,
        padding: EdgeInsets.all(6.07 * scale),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
            color: bgGray200,
            width: 0.379 * scale,
          ),
          borderRadius: BorderRadius.circular(5.308 * scale),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0.379 * scale),
              blurRadius: 1.137 * scale,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0.379 * scale),
              blurRadius: 0.758 * scale,
              spreadRadius: -0.379 * scale,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.166 * scale,
              height: 15.166 * scale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2B7FFF), Color(0xFF00B8DB)],
                ),
                borderRadius: BorderRadius.circular(5.308 * scale),
              ),
              child: Icon(
                Icons.people,
                size: 7.583 * scale,
                color: white,
              ),
            ),
            SizedBox(height: 3.038 * scale),
            Text(
              'Team',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.066 * scale,
                fontWeight: FontWeight.w400,
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangesButton(double scale) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangeOrderPage()),
        );
      },
      child: Container(
        height: 40.19 * scale,
        padding: EdgeInsets.all(6.07 * scale),
        decoration: BoxDecoration(
          color: white,
          border: Border.all(
            color: bgGray200,
            width: 0.379 * scale,
          ),
          borderRadius: BorderRadius.circular(5.308 * scale),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0.379 * scale),
              blurRadius: 1.137 * scale,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 0.379 * scale),
              blurRadius: 0.758 * scale,
              spreadRadius: -0.379 * scale,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 15.166 * scale,
              height: 15.166 * scale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6900), Color(0xFFFB2C36)],
                ),
                borderRadius: BorderRadius.circular(5.308 * scale),
              ),
              child: Icon(
                Icons.change_circle,
                size: 7.583 * scale,
                color: white,
              ),
            ),
            SizedBox(height: 3.038 * scale),
            Text(
              'Changes',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.066 * scale,
                fontWeight: FontWeight.w400,
                color: textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(double scale, Map<String, dynamic> activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.066 * scale),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12.133 * scale,
            height: 12.133 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2B7FFF), Color(0xFF155DFC)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF155DFC).withOpacity(0.3),
                  offset: Offset(0, 3.791 * scale),
                  blurRadius: 5.687 * scale,
                  spreadRadius: -1.137 * scale,
                ),
                BoxShadow(
                  color: Color(0xFF155DFC).withOpacity(0.3),
                  offset: Offset(0, 1.517 * scale),
                  blurRadius: 2.275 * scale,
                  spreadRadius: -1.517 * scale,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 3.033 * scale,
                height: 3.033 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: white,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.556 * scale),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'] ?? '',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.066 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                  ),
                ),
                SizedBox(height: 0.76 * scale),
                Text(
                  '${activity['author'] ?? ''} • ${activity['time'] ?? ''}',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.066 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Task> _getSortedTasks() {
    // Sort tasks: in progress first, then completed, then others
    final sortedTasks = List<Task>.from(_tasks);
    sortedTasks.sort((a, b) {
      final aStatus = a.status.toLowerCase();
      final bStatus = b.status.toLowerCase();
      
      // Priority order: "in progress" > "completed" > others
      int getPriority(String status) {
        if (status == 'in progress') return 0;
        if (status == 'completed') return 1;
        return 2;
      }
      
      final aPriority = getPriority(aStatus);
      final bPriority = getPriority(bStatus);
      
      if (aPriority != bPriority) {
        return aPriority.compareTo(bPriority);
      }
      
      // If same priority, maintain original order
      return 0;
    });
    
    return sortedTasks;
  }

  Widget _buildTasksContent(double scale) {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(9.092 * scale),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(9.092 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: All Tasks + Add Task button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All Tasks',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 7.5 * scale, // Increased font size
                  fontWeight: FontWeight.w500,
                  color: textDark,
                ),
              ),
              GestureDetector(
                onTap: () => _addNewTask(context, scale),
                child: Container(
                  height: 18.0 * scale,
                  padding: EdgeInsets.symmetric(horizontal: 6.0 * scale),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryBlue, primaryBlueDark],
                    ),
                    borderRadius: BorderRadius.circular(5.304 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.25),
                        offset: Offset(0, 3.788 * scale),
                        blurRadius: 5.682 * scale,
                        spreadRadius: -1.136 * scale,
                      ),
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.25),
                        offset: Offset(0, 1.515 * scale),
                        blurRadius: 2.273 * scale,
                        spreadRadius: -1.515 * scale,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 7.5 * scale,
                        color: white,
                      ),
                      SizedBox(width: 3.0 * scale),
                      Text(
                        'Add Task',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 6.5 * scale,
                          fontWeight: FontWeight.w400,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.061 * scale),
          // Task Cards
          if (_tasks.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(9.092 * scale),
                child: Text(
                  'No tasks found',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.061 * scale,
                    color: textGray,
                  ),
                ),
              ),
            )
          else
            ..._getSortedTasks().map((task) {
              return _buildTaskCard(scale, task);
            }),
        ],
      ),
    );
  }

  Widget _buildTaskCard(double scale, Task task) {
    final colors = task.getBadgeColors();
    final isCompleted = task.status.toLowerCase() == 'completed' || task.progress == 100;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.0 * scale),
      padding: EdgeInsets.all(10.0 * scale), // Reduced padding to decrease height
      decoration: BoxDecoration(
        color: isCompleted ? Color(0xFFEFF6FF) : white,
        border: Border.all(
          color: isCompleted ? primaryBlue.withOpacity(0.4) : Color(0xFFE5E7EB),
          width: isCompleted ? 1.5 * scale : 1.0 * scale,
        ),
        borderRadius: BorderRadius.circular(12.0 * scale), // More rounded corners
        boxShadow: [
          BoxShadow(
            color: isCompleted 
              ? primaryBlue.withOpacity(0.2)
              : Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, 4.0 * scale),
            blurRadius: 12.0 * scale,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            offset: Offset(0, 2.0 * scale),
            blurRadius: 6.0 * scale,
            spreadRadius: -1.0 * scale,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Action Icons Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 9.0 * scale, // Further increased font size
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? primaryBlue : textDark,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 4.0 * scale),
                    // Badges Row
                    Wrap(
                      spacing: 6.0 * scale,
                      runSpacing: 4.0 * scale,
                      children: [
                        _buildBadge(scale, task.trade, Color(colors['tradeColor']), Color(colors['tradeTextColor']), null),
                        _buildBadge(scale, task.status, Color(colors['statusColor']), Color(colors['statusTextColor']), Color(colors['statusBorderColor'])),
                        _buildBadge(scale, task.priority, Color(colors['priorityColor']), Color(colors['priorityTextColor']), Color(colors['priorityBorderColor'])),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.0 * scale),
              // Edit and Delete Icons - Larger and more modern
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _editTask(context, scale, {
                      'id': task.id,
                      'name': task.name,
                      'trade': task.trade,
                      'status': task.status,
                      'priority': task.priority,
                      'progress': task.progress,
                      'startDate': task.startDate,
                      'endDate': task.endDate,
                      'assignedTo': task.assignedTo,
                      'assignedToName': task.assignedToName,
                    }),
                    child: Container(
                      width: 16.0 * scale, // Increased size
                      height: 16.0 * scale,
                      decoration: BoxDecoration(
                        color: isCompleted ? primaryBlue.withOpacity(0.1) : bgGray50,
                        borderRadius: BorderRadius.circular(6.0 * scale),
                      ),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 8.5 * scale, // Increased icon size
                        color: isCompleted ? primaryBlue : textGrayDark,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.0 * scale),
                  GestureDetector(
                    onTap: () => _showDeleteDialog(context, scale, {
                      'id': task.id,
                      'name': task.name,
                    }),
                    child: Container(
                      width: 16.0 * scale, // Increased size
                      height: 16.0 * scale,
                      decoration: BoxDecoration(
                        color: isCompleted ? primaryBlue.withOpacity(0.1) : bgGray50,
                        borderRadius: BorderRadius.circular(6.0 * scale),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 8.5 * scale, // Increased icon size
                        color: isCompleted ? primaryBlue : textGrayDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.0 * scale),
          // Date Range
          Container(
            padding: EdgeInsets.symmetric(vertical: 3.0 * scale),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isCompleted ? primaryBlue.withOpacity(0.2) : bgGray200,
                  width: 0.5 * scale,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 3.0 * scale),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 8.0 * scale, // Increased icon size
                    color: isCompleted ? primaryBlue : textGrayDark,
                  ),
                  SizedBox(width: 6.0 * scale),
                  Text(
                    task.startDate,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 7.0 * scale, // Increased font size
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? primaryBlue : textDark,
                    ),
                  ),
                  SizedBox(width: 8.0 * scale),
                  Text(
                    '→',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 7.0 * scale,
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? primaryBlue : textGray,
                    ),
                  ),
                  SizedBox(width: 8.0 * scale),
                  Text(
                    task.endDate,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 7.0 * scale, // Increased font size
                      fontWeight: FontWeight.w500,
                      color: isCompleted ? primaryBlue : textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Assigned To
          if (task.assignedToName != null) ...[
            SizedBox(height: 3.0 * scale),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3.0 * scale),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isCompleted ? primaryBlue.withOpacity(0.2) : bgGray200,
                    width: 0.5 * scale,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 3.0 * scale),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 8.0 * scale, // Increased icon size
                      color: isCompleted ? primaryBlue : textGrayDark,
                    ),
                    SizedBox(width: 6.0 * scale),
                    Text(
                      'Assigned to:',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 7.0 * scale, // Increased font size
                        fontWeight: FontWeight.w500,
                        color: isCompleted ? primaryBlue : textGrayDark,
                      ),
                    ),
                    SizedBox(width: 6.0 * scale),
                    Text(
                      task.assignedToName ?? '',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 7.0 * scale, // Increased font size
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? primaryBlue : textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBadge(double scale, String text, Color bgColor, Color textColor, Color? borderColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0 * scale, vertical: 2.5 * scale), // Increased padding
      decoration: BoxDecoration(
        color: bgColor,
        border: borderColor != null ? Border.all(
          color: borderColor,
          width: 0.5 * scale,
        ) : null,
        borderRadius: BorderRadius.circular(5.0 * scale), // More rounded
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Arimo',
          fontSize: 5.5 * scale, // Increased font size
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }

  void _editTask(BuildContext context, double scale, Map<String, dynamic>? taskData) {
    final task = taskData != null ? _tasks.firstWhere((t) => t.id == taskData['id']) : null;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: true,
      builder: (context) => EditTask(
        task: task,
        projectId: widget.project['id']?.toString() ?? 'default',
      ),
    ).then((result) {
      if (result != null && result is Task) {
        setState(() {
          if (task != null) {
            final index = _tasks.indexWhere((t) => t.id == result.id);
            if (index != -1) {
              _tasks[index] = result;
            }
          } else {
            _tasks.add(result);
          }
        });
      }
    });
  }

  void _addNewTask(BuildContext context, double scale) {
    _editTask(context, scale, null);
  }

  void _showDeleteDialog(BuildContext context, double scale, Map<String, dynamic> taskData) {
    if (!mounted) return;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive values (same as logout popup)
    final dialogPadding = (screenWidth * 0.06).clamp(20.0, 24.0);
    final dialogMaxWidth = (screenWidth * 0.85).clamp(280.0, 340.0);
    final borderRadius = (screenWidth * 0.06).clamp(20.0, 24.0);
    final iconSize = (screenWidth * 0.06).clamp(20.0, 24.0);
    final closeIconSize = (screenWidth * 0.05).clamp(18.0, 20.0);
    final titleFontSize = (screenWidth * 0.05).clamp(18.0, 20.0);
    final messageFontSize = (screenWidth * 0.038).clamp(14.0, 15.0);
    final buttonHeight = (screenHeight * 0.06).clamp(44.0, 48.0);
    final buttonIconSize = (screenWidth * 0.045).clamp(16.0, 18.0);
    final buttonFontSize = (screenWidth * 0.038).clamp(14.0, 15.0);
    final buttonBorderRadius = (screenWidth * 0.03).clamp(10.0, 12.0);
    final spacing1 = (screenHeight * 0.025).clamp(16.0, 20.0);
    final spacing2 = (screenHeight * 0.035).clamp(24.0, 28.0);
    final buttonSpacing = (screenWidth * 0.03).clamp(10.0, 12.0);

    final taskName = taskData['name'] as String? ?? 'this task';
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 24,
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(dialogPadding),
          constraints: BoxConstraints(maxWidth: dialogMaxWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with warning icon, title, and close button
              Stack(
                children: [
                  Row(
                    children: [
                      // Warning icon
                      Image.asset(
                        'assets/icons/warning_icon.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                      SizedBox(width: dialogPadding * 0.5),
                      // Title
                      Text(
                        'Delete Task?',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  // Close button
                  Positioned(
                    right: 0,
                    top: -4,
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.of(dialogContext).canPop()) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          size: closeIconSize,
                          color: const Color(0xFF6E6E6E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing1),
              // Message
              Text(
                'Are you sure you want to delete $taskName? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: messageFontSize,
                  color: const Color(0xFF6E6E6E),
                  height: 1.4,
                ),
              ),
              SizedBox(height: spacing2),
              // Buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: Container(
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(buttonBorderRadius),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0),
                          width: 1.5,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.of(dialogContext).canPop()) {
                            Navigator.of(dialogContext).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              color: const Color(0xFF1F2937),
                              size: buttonIconSize,
                            ),
                            SizedBox(width: buttonSpacing * 0.67),
                            Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: buttonFontSize,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: buttonSpacing),
                  // Delete button
                  Expanded(
                    child: Container(
                      height: buttonHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFB2C36),
                        borderRadius: BorderRadius.circular(buttonBorderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFB2C36).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final taskId = taskData['id'] as String?;
                          if (taskId != null) {
                            try {
                              await _projectService.deleteTask(taskId);
                              if (mounted) {
                                setState(() {
                                  _tasks.removeWhere((t) => t.id == taskId);
                                });
                                // Close delete confirmation dialog
                                if (Navigator.of(dialogContext).canPop()) {
                                  Navigator.of(dialogContext).pop();
                                }
                                // Show delete success animation
                                _showDeleteSuccessAnimation(context, scale);
                              }
                            } catch (e) {
                              if (mounted) {
                                if (Navigator.of(dialogContext).canPop()) {
                                  Navigator.of(dialogContext).pop();
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error deleting task: $e')),
                                );
                              }
                            }
                          } else {
                            if (Navigator.of(dialogContext).canPop()) {
                              Navigator.of(dialogContext).pop();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFB2C36),
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(buttonBorderRadius),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/delete_icon.png',
                              width: buttonIconSize,
                              height: buttonIconSize,
                              color: Colors.white,
                            ),
                            SizedBox(width: buttonSpacing * 0.67),
                            Text(
                              'Delete',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: buttonFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog(BuildContext context, double scale) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 25 * scale, vertical: 40 * scale),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: 120 * scale),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12.0 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: Offset(0, 8.0 * scale),
                blurRadius: 20.0 * scale,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: primaryBlue.withOpacity(0.1),
                offset: Offset(0, 4.0 * scale),
                blurRadius: 12.0 * scale,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Header with gradient background
              Container(
                height: 50 * scale,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryBlue, primaryBlueDark],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0 * scale),
                    topRight: Radius.circular(12.0 * scale),
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      right: -20 * scale,
                      top: -20 * scale,
                      child: Container(
                        width: 60 * scale,
                        height: 60 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -15 * scale,
                      bottom: -15 * scale,
                      child: Container(
                        width: 40 * scale,
                        height: 40 * scale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                    ),
                    // Header content
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            size: 10.0 * scale,
                            color: white,
                          ),
                          SizedBox(width: 4.0 * scale),
                          Text(
                            'Share Project',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 7.5 * scale,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Close button
              Positioned(
                right: 8 * scale,
                top: 8 * scale,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 10 * scale,
                    height: 10 * scale,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 6.0 * scale,
                      color: white,
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(18 * scale),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20 * scale),
                    Text(
                      'Choose what to share:',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 5.5 * scale,
                        fontWeight: FontWeight.w400,
                        color: white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20 * scale),
                    _buildShareOption(scale, Icons.bar_chart, 'Graph Chart', LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF9C27B0), Color(0xFFFF6B9D)],
                    ), () {
                      Navigator.of(context).pop();
                      _shareGraphChart();
                    }),
                    SizedBox(height: 12 * scale),
                    _buildShareOption(scale, Icons.description, 'Project Report', LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryBlue, primaryBlueDark],
                    ), () {
                      Navigator.of(context).pop();
                      _shareProjectReport();
                    }),
                    SizedBox(height: 8 * scale),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareOption(double scale, IconData icon, String label, Gradient? gradient, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0 * scale),
        splashColor: Colors.white.withOpacity(0.2),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          height: 24 * scale,
          padding: EdgeInsets.symmetric(horizontal: 12 * scale, vertical: 6 * scale),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(8.0 * scale),
            boxShadow: [
              BoxShadow(
                color: (gradient != null 
                    ? gradient.colors.first
                    : primaryBlue).withOpacity(0.3),
                offset: Offset(0, 3 * scale),
                blurRadius: 6 * scale,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: (gradient != null 
                    ? gradient.colors.first
                    : primaryBlue).withOpacity(0.2),
                offset: Offset(0, 1 * scale),
                blurRadius: 2 * scale,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(2 * scale),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 8.5 * scale,
                  color: white,
                ),
              ),
              SizedBox(width: 8 * scale),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.5 * scale,
                    fontWeight: FontWeight.w600,
                    color: white,
                    letterSpacing: 0.2,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _shareGraphChart() async {
    final data = projectData;
    final shareText = 'Graph Chart for ${data['name']}\n\n'
        'Progress: ${data['progress']}%\n'
        'Total Budget: ${data['totalBudget']}\n'
        'Cost to Date: ${data['costToDate']}\n'
        'Remaining: ${data['remaining']}';
    
    await Share.share(shareText, subject: '${data['name']} - Graph Chart');
  }

  Future<void> _shareProjectReport() async {
    final data = projectData;
    final shareText = 'Project Report: ${data['name']}\n\n'
        'Managed by: ${data['manager']}\n'
        'Progress: ${data['progress']}%\n'
        'Start Date: ${data['startDate']}\n'
        'End Date: ${data['endDate']}\n'
        'Total Budget: ${data['totalBudget']}\n'
        'Cost to Date: ${data['costToDate']}\n'
        'Remaining: ${data['remaining']}\n'
        'Change Orders: ${data['changeOrders']}';
    
    await Share.share(shareText, subject: '${data['name']} - Project Report');
  }

  Widget _buildGanttContent(double scale) {
    // Get date range from tasks for timeline
    final dateRange = _getGanttDateRange();
    final months = _generateMonthLabels(dateRange['start']!, dateRange['end']!);
    
    return Container(
      padding: EdgeInsets.all(7.76 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Project Timeline with calendar icon
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 7.765 * scale,
                color: textDark,
              ),
              SizedBox(width: 3.106 * scale),
              Text(
                'Project Timeline',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.212 * scale,
                  fontWeight: FontWeight.w400,
                  color: textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.106 * scale),
          
          // Gantt Chart Container
          Container(
            decoration: BoxDecoration(
              color: white,
              border: Border.all(
                color: bgGray200,
                width: 0.388 * scale,
              ),
              borderRadius: BorderRadius.circular(6.212 * scale),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0.388 * scale),
                  blurRadius: 1.165 * scale,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 0.388 * scale),
                  blurRadius: 0.776 * scale,
                  spreadRadius: -0.388 * scale,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header row
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.76 * scale,
                    vertical: 7.76 * scale,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: bgGray200,
                        width: 0.388 * scale,
                      ),
                    ),
                  ),
                  child: _buildDateHeader(scale, months),
                ),
                
                // Task rows
                Padding(
                  padding: EdgeInsets.all(7.76 * scale),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final timelineWidth = constraints.maxWidth;
                      return Column(
                        children: _tasks.map((task) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 6.212 * scale),
                            child: _buildGanttTaskRow(scale, task, dateRange['start']!, dateRange['end']!, months, timelineWidth),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                
                // Legend
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 7.76 * scale,
                    vertical: 7.76 * scale,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: bgGray200,
                        width: 0.388 * scale,
                      ),
                    ),
                  ),
                  child: _buildLegend(scale),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper: Get date range from all tasks for timeline
  Map<String, DateTime> _getGanttDateRange() {
    DateTime? earliestStart;
    DateTime? latestEnd;
    
    for (var task in _tasks) {
      final start = _parseDate(task.startDate);
      final end = _parseDate(task.endDate);
      
      if (start != null && (earliestStart == null || start.isBefore(earliestStart))) {
        earliestStart = start;
      }
      if (end != null && (latestEnd == null || end.isAfter(latestEnd))) {
        latestEnd = end;
      }
    }
    
    // Default to current month if no tasks
    final now = DateTime.now();
    earliestStart ??= DateTime(now.year, now.month, 1);
    latestEnd ??= DateTime(now.year, now.month + 6, 0);
    
    // Round to month boundaries
    earliestStart = DateTime(earliestStart.year, earliestStart.month, 1);
    latestEnd = DateTime(latestEnd.year, latestEnd.month + 1, 0);
    
    return {
      'start': earliestStart,
      'end': latestEnd,
    };
  }

  // Helper: Parse date string like "Sep 15" or "15/9/2024"
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    
    try {
      // Try "Sep 15" format
      final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final parts = dateStr.trim().split(' ');
      if (parts.length >= 2) {
        final monthIndex = monthNames.indexOf(parts[0]);
        if (monthIndex != -1) {
          final day = int.parse(parts[1]);
          // Use current year or next year if month is in the past
          final now = DateTime.now();
          var year = now.year;
          if (monthIndex < now.month - 1) {
            year = now.year + 1;
          }
          return DateTime(year, monthIndex + 1, day);
        }
      }
      
      // Try "15/9/2024" format
      final slashParts = dateStr.split('/');
      if (slashParts.length == 3) {
        return DateTime(
          int.parse(slashParts[2]),
          int.parse(slashParts[1]),
          int.parse(slashParts[0]),
        );
      }
    } catch (e) {
      // Return null if parsing fails
    }
    
    return null;
  }

  // Helper: Generate month labels for timeline
  List<Map<String, dynamic>> _generateMonthLabels(DateTime start, DateTime end) {
    final months = <Map<String, dynamic>>[];
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    var current = DateTime(start.year, start.month, 1);
    final endMonth = DateTime(end.year, end.month, 1);
    
    while (current.isBefore(endMonth) || current.isAtSameMomentAs(endMonth)) {
      months.add({
        'date': current,
        'label': '${monthNames[current.month - 1]} ${current.year.toString().substring(2)}',
      });
      current = DateTime(current.year, current.month + 1, 1);
    }
    
    return months;
  }

  // Build date header row
  Widget _buildDateHeader(double scale, List<Map<String, dynamic>> months) {
    return Row(
      children: months.map((month) {
        return Expanded(
          child: Center(
            child: Text(
              month['label'] as String,
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.212 * scale,
                fontWeight: FontWeight.w400,
                color: textGrayDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Build a single Gantt task row
  Widget _buildGanttTaskRow(double scale, Task task, DateTime timelineStart, DateTime timelineEnd, List<Map<String, dynamic>> months, double timelineWidth) {
    final startDate = _parseDate(task.startDate);
    final endDate = _parseDate(task.endDate);
    
    // Calculate bar position and width
    double barLeft = 0;
    double barWidth = 0;
    
    if (startDate != null && endDate != null) {
      final totalDays = timelineEnd.difference(timelineStart).inDays;
      final taskStartOffset = startDate.difference(timelineStart).inDays;
      final taskDuration = endDate.difference(startDate).inDays;
      
      if (totalDays > 0 && timelineWidth > 0) {
        final leftPercent = (taskStartOffset / totalDays).clamp(0.0, 1.0);
        final widthPercent = (taskDuration / totalDays).clamp(0.0, 1.0);
        barLeft = leftPercent * timelineWidth;
        barWidth = widthPercent * timelineWidth;
        // Ensure minimum width for visibility
        if (barWidth < 10 * scale) {
          barWidth = 10 * scale;
        }
      }
    }
    
    // Get bar color based on status
    Color barColor1;
    Color barColor2;
    if (task.progress == 100 || task.status.toLowerCase() == 'completed') {
      barColor1 = const Color(0xFF00C950); // Green
      barColor2 = const Color(0xFF00A63E);
    } else if (task.status.toLowerCase() == 'in progress' || task.progress > 0) {
      barColor1 = const Color(0xFF2B7FFF); // Blue
      barColor2 = const Color(0xFF155DFC);
    } else {
      barColor1 = const Color(0xFFD1D5DC); // Gray
      barColor2 = const Color(0xFF99A1AF);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Task name and trade badge row
        Row(
          children: [
            Expanded(
              child: Text(
                task.name,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: textDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 3.106 * scale),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 3.106 * scale,
                vertical: 0.776 * scale,
              ),
              decoration: BoxDecoration(
                color: bgGray50,
                borderRadius: BorderRadius.circular(1.553 * scale),
              ),
              child: Text(
                task.trade,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 4.659 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.106 * scale),
        
        // Timeline bar container
        Container(
          height: 15.529 * scale,
          decoration: BoxDecoration(
            color: bgGray50,
            borderRadius: BorderRadius.circular(3.882 * scale),
          ),
          child: Stack(
            children: [
              // Month dividers
              Row(
                children: months.asMap().entries.map((entry) {
                  final isLast = entry.key == months.length - 1;
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: isLast
                              ? BorderSide.none
                              : BorderSide(
                                  color: bgGray200,
                                  width: 0.388 * scale,
                                ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              // Task bar
              if (barWidth > 0)
                Positioned(
                  left: barLeft,
                  width: barWidth,
                  top: 2.33 * scale,
                  child: Container(
                    height: 10.871 * scale,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [barColor1, barColor2],
                      ),
                      borderRadius: BorderRadius.circular(3.882 * scale),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(0, 0.388 * scale),
                          blurRadius: 1.165 * scale,
                          spreadRadius: 0,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(0, 0.388 * scale),
                          blurRadius: 0.776 * scale,
                          spreadRadius: -0.388 * scale,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // White overlay gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Color.fromRGBO(255, 255, 255, 0.3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(3.882 * scale),
                            ),
                          ),
                        ),
                        // Progress percentage
                        Center(
                          child: Text(
                            '${task.progress}%',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 4.659 * scale,
                              fontWeight: FontWeight.w400,
                              color: white,
                              shadows: [
                                Shadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.15),
                                  offset: Offset(0, 0.388 * scale),
                                  blurRadius: 1.553 * scale,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 3.106 * scale),
        
        // Start and end dates
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (startDate != null)
              Text(
                _formatDateShort(startDate),
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 4.659 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray,
                ),
              )
            else
              SizedBox.shrink(),
            if (endDate != null)
              Text(
                _formatDateShort(endDate),
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 4.659 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray,
                ),
              )
            else
              SizedBox.shrink(),
          ],
        ),
      ],
    );
  }

  // Format date to "Sep 15" format
  String _formatDateShort(DateTime date) {
    final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${monthNames[date.month - 1]} ${date.day}';
  }

  // Build legend
  Widget _buildLegend(double scale) {
    return Row(
      children: [
        _buildLegendItem(scale, const Color(0xFF00C950), const Color(0xFF00A63E), 'Completed'),
        SizedBox(width: 6.212 * scale),
        _buildLegendItem(scale, const Color(0xFF2B7FFF), const Color(0xFF155DFC), 'In Progress'),
        SizedBox(width: 6.212 * scale),
        _buildLegendItem(scale, const Color(0xFFD1D5DC), const Color(0xFF99A1AF), 'Not Started'),
      ],
    );
  }

  Widget _buildLegendItem(double scale, Color color1, Color color2, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.212 * scale,
          height: 6.212 * scale,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color1, color2],
            ),
            borderRadius: BorderRadius.circular(1.553 * scale),
          ),
        ),
        SizedBox(width: 3.106 * scale),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.435 * scale,
            fontWeight: FontWeight.w400,
            color: textGrayDark,
          ),
        ),
      ],
    );
  }

  void _showDeleteSuccessAnimation(BuildContext context, double scale) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(
            horizontal: 35 * scale,
            vertical: 60 * scale,
          ),
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxWidth: 120 * scale,
                maxHeight: MediaQuery.of(context).size.height * 0.65,
              ),
              padding: EdgeInsets.all(12 * scale),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.984 * scale),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 25 * scale,
                    spreadRadius: 5 * scale,
                  ),
                  BoxShadow(
                    color: const Color(0xFFDC2626).withOpacity(0.1), // Red shadow
                    blurRadius: 15 * scale,
                    spreadRadius: 2 * scale,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Beautiful animated delete icon with red theme colors
                  _buildAnimatedDeleteIcon(scale),
                  SizedBox(height: 10 * scale),
                  Text(
                    'Task Deleted!',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 7.091 * scale,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 5 * scale),
                  Text(
                    'The task has been\nsuccessfully deleted',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.008 * scale,
                      fontWeight: FontWeight.w400,
                      color: textGray,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12 * scale),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // Close success dialog (stays on same page)
                      },
                      borderRadius: BorderRadius.circular(5.508 * scale),
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.2),
                      child: Ink(
                        width: double.infinity,
                        height: 18.885 * scale,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFDC2626), Color(0xFFB91C1C)], // Red gradient
                          ),
                          borderRadius: BorderRadius.circular(5.508 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFDC2626).withOpacity(0.3),
                              offset: Offset(0, 3.934 * scale),
                              blurRadius: 5.902 * scale,
                              spreadRadius: -1.18 * scale,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 5.508 * scale,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedDeleteIcon(double scale) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        // Clamp opacity values to prevent assertion errors
        final outerOpacity = (0.05 * (1 - value)).clamp(0.0, 1.0);
        final middleOpacity = (0.08 * (1 - value)).clamp(0.0, 1.0);
        final innerOpacity = (0.12 * (1 - value)).clamp(0.0, 1.0);
        
        // Rotation animation for more dynamic effect
        final rotation = value * 360;
        
        // Red color constants
        const redPrimary = Color(0xFFDC2626);
        const redDark = Color(0xFFB91C1C);
        
        return SizedBox(
          width: 65 * scale,
          height: 65 * scale,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Outer pulsing circle - largest with rotation (red)
              Transform.rotate(
                angle: rotation * 0.5 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.25).clamp(0.0, 1.3),
                  child: Container(
                    width: 65 * scale,
                    height: 65 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: redPrimary.withOpacity(outerOpacity),
                    ),
                  ),
                ),
              ),
              // Middle pulsing circle with rotation (red)
              Transform.rotate(
                angle: -rotation * 0.3 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.15).clamp(0.0, 1.2),
                  child: Container(
                    width: 55 * scale,
                    height: 55 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: redPrimary.withOpacity(middleOpacity),
                    ),
                  ),
                ),
              ),
              // Inner circle with rotation (red)
              Transform.rotate(
                angle: rotation * 0.2 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.08).clamp(0.0, 1.1),
                  child: Container(
                    width: 45 * scale,
                    height: 45 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: redPrimary.withOpacity(innerOpacity),
                    ),
                  ),
                ),
              ),
              // Main circle with X icon - red gradient (no rotation, just scale)
              Transform.scale(
                scale: value.clamp(0.0, 1.0),
                child: Container(
                  width: 38 * scale,
                  height: 38 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [redPrimary, redDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: redPrimary.withOpacity(0.6),
                        blurRadius: 12 * scale,
                        spreadRadius: 5 * scale,
                      ),
                      BoxShadow(
                        color: redPrimary.withOpacity(0.4),
                        blurRadius: 8 * scale,
                        spreadRadius: 2 * scale,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close, // X icon instead of check
                    size: 24 * scale,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


