import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../Add New Member/addnewmember.dart';
import '../Welcome Dashboard/welcomedashboard.dart';
import '../create new project/createnewproject.dart';
import '../projectdashboard/projectdashbaoard.dart';
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
  Duration get transitionDuration => Duration.zero; // No animation

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Return child directly without any transition
    return child;
  }
}

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All'; // All, Active, Completed, Draft
  AnimationController? _fadeController;
  Animation<double> get _fadeAnimation {
    return _fadeController != null
        ? CurvedAnimation(
            parent: _fadeController!,
            curve: Curves.easeIn,
          )
        : const AlwaysStoppedAnimation(1.0);
  }
  
  // Sample project data matching Figma
  final List<Map<String, dynamic>> _allProjects = [
    {
      'name': 'Riverside Office Complex',
      'location': '1234 Main St, San Francisco, CA',
      'manager': 'Sarah Johnson',
      'status': 'active',
      'progress': 68,
      'startDate': 'Started Sep 15, 2024',
      'budget': '\$2.5M',
    },
    {
      'name': 'Downtown Residential Tower',
      'location': '890 Market St, Oakland, CA',
      'manager': 'Mike Chen',
      'status': 'active',
      'progress': 34,
      'startDate': 'Started Oct 22, 2024',
      'budget': '\$5.8M',
    },
    {
      'name': 'Westside Shopping Center',
      'location': '456 Commerce Ave, Berkeley, CA',
      'manager': 'Emily Rodriguez',
      'status': 'completed',
      'progress': 100,
      'startDate': 'Started Mar 10, 2024',
      'budget': '\$1.2M',
    },
    {
      'name': 'Lakefront Community Center',
      'location': '321 Lake Dr, Palo Alto, CA',
      'manager': 'David Kim',
      'status': 'active',
      'progress': 15,
      'startDate': 'Started Nov 5, 2024',
      'budget': '\$0.9M',
    },
    {
      'name': 'Highland Medical Facility',
      'location': '789 Health Way, San Jose, CA',
      'manager': 'Anna Martinez',
      'status': 'draft',
      'progress': 0,
      'startDate': 'Started Nov 12, 2024',
      'budget': '\$3.4M',
    },
  ];

  List<Map<String, dynamic>> get _filteredProjects {
    String searchQuery = _searchController.text.toLowerCase();
    
    List<Map<String, dynamic>> filtered = _allProjects;
    
    // Filter by status
    if (_selectedFilter != 'All') {
      filtered = filtered.where((project) => 
        project['status'].toLowerCase() == _selectedFilter.toLowerCase()
      ).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        final name = project['name'].toString().toLowerCase();
        final location = project['location'].toString().toLowerCase();
        final manager = project['manager'].toString().toLowerCase();
        return name.contains(searchQuery) || 
               location.contains(searchQuery) || 
               manager.contains(searchQuery);
      }).toList();
    }
    
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController!.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController?.dispose();
    super.dispose();
  }

  // Exact colors from Figma design
  static const Color primaryBlue = Color(0xFF2779F5);
  static const Color filterBlue = Color(0xFF155DFC);
  static const Color textDark = Color(0xFF101828);
  static const Color textGray = Color(0xFF6A7282);
  static const Color bgGray50 = Color(0xFFF9FAFB);
  static const Color bgGray100 = Color(0xFFF3F4F6);
  static const Color bgGray200 = Color(0xFFE5E7EB);
  static const Color inputBg = Color(0xFFF3F3F5);
  static const Color activeBadgeBg = Color(0xFFDBEAFE);
  static const Color activeBadgeBorder = Color(0xFFBEDBFF);
  static const Color activeBadgeText = Color(0xFF1447E6);
  static const Color completedBadgeBg = Color(0xFFD1FAE5);
  static const Color completedBadgeBorder = Color(0xFFB9F8CF);
  static const Color completedBadgeText = Color(0xFF008236);
  static const Color draftBadgeBg = Color(0xFFF3F4F6);
  static const Color draftBadgeBorder = Color(0xFFE5E7EB);
  static const Color draftBadgeText = Color(0xFF364153);
  static const Color progressBg = Color(0xFF030213);
  static const Color progressBgLight = Color(0x33030213);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 167.0; // Based on Figma design width

    return Scaffold(
      backgroundColor: bgGray50,
      extendBody: true,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, // Projects is selected
        onTap: (index) {
          if (index == 0) {
            // Already on Projects page - do nothing
            return;
          } else if (index == 1) {
            // Role button - navigate to add member
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const AddNewMember(),
              ),
              (route) => false, // Remove all previous routes
            );
          } else if (index == 2) {
            // Dashboard button - navigate to dashboard
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const WelcomeDashboard(),
              ),
              (route) => false, // Remove all previous routes
            );
          } else if (index == 3) {
            // Settings button - navigate to Settings page
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const SettingsPage(),
              ),
              (route) => false, // Remove all previous routes
            );
          } else if (index == 4) {
            // Logout
            LogoutDialog.show(context);
          }
        },
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: bgGray50,
            child: Column(
              children: [
                // Header Section
                _buildHeader(scale),
                // Search and Filters
                _buildSearchAndFilters(scale),
                // Projects List
                Expanded(
                  child: _buildProjectsList(scale),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildNewProjectButton(scale),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader(double scale) {
    // Calculate total project count dynamically
    final totalProjects = _allProjects.length;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(9.43 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: bgGray200,
            width: 0.393 * scale,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2 * scale),
            blurRadius: 4 * scale,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Logo with shadow
          Container(
            width: 18.861 * scale,
            height: 18.861 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: primaryBlue.withOpacity(0.2),
                width: 0.786 * scale,
              ),
              borderRadius: BorderRadius.circular(6.287 * scale),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(0, 1 * scale),
                  blurRadius: 2 * scale,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 11.002 * scale,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Arimo',
                ),
              ),
            ),
          ),
          SizedBox(width: 4.715 * scale),
          // Title and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Projects',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.287 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: 1.572 * scale), // Gap between title and count
                Text(
                  '$totalProjects projects',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.287 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(double scale) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 9.43 * scale,
        vertical: 9.43 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            width: double.infinity,
            height: 17.289 * scale,
            decoration: BoxDecoration(
              color: inputBg,
              border: Border.all(
                color: bgGray200,
                width: 0.393 * scale,
              ),
              borderRadius: BorderRadius.circular(5.501 * scale),
            ),
            child: Row(
              children: [
                SizedBox(width: 4.72 * scale),
                Icon(
                  Icons.search,
                  size: 7.859 * scale,
                  color: textGray,
                ),
                SizedBox(width: 4.715 * scale),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 6.287 * scale,
                      color: const Color(0xFF717182),
                    ),
                    onChanged: (value) {
                      setState(() {}); // Rebuild to update filtered list
                    },
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      hintStyle: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 6.287 * scale,
                        color: const Color(0xFF717182),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 1.572 * scale,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 9.43 * scale),
          // Filter Buttons
          Row(
            children: [
              _buildFilterButton(scale, 'All'),
              SizedBox(width: 3.144 * scale),
              _buildFilterButton(scale, 'Active'),
              SizedBox(width: 3.144 * scale),
              _buildFilterButton(scale, 'Completed'),
              SizedBox(width: 3.144 * scale),
              _buildFilterButton(scale, 'Draft'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(double scale, String label) {
    final isSelected = _selectedFilter == label;
    // Increase width for "All" button
    final minWidth = label == 'All' ? 25.0 * scale : null;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        height: 16.504 * scale,
        constraints: minWidth != null ? BoxConstraints(minWidth: minWidth) : null,
        padding: EdgeInsets.symmetric(horizontal: label == 'All' ? 6.0 * scale : 3.144 * scale),
        decoration: BoxDecoration(
          color: isSelected ? filterBlue : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.transparent : bgGray200,
            width: 0.393 * scale,
          ),
          borderRadius: BorderRadius.circular(3.929 * scale),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: filterBlue.withOpacity(0.25),
                    offset: Offset(0, 3.929 * scale),
                    blurRadius: 5.894 * scale,
                    spreadRadius: -1.179 * scale,
                  ),
                  BoxShadow(
                    color: filterBlue.withOpacity(0.25),
                    offset: Offset(0, 1.572 * scale),
                    blurRadius: 2.358 * scale,
                    spreadRadius: -1.572 * scale,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 6.287 * scale,
              fontWeight: FontWeight.w400,
              color: isSelected ? Colors.white : const Color(0xFF4A5565),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsList(double scale) {
    final projects = _filteredProjects;
    
    if (projects.isEmpty) {
      return Center(
        child: Text(
          'No projects found',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 6.287 * scale,
            color: textGray,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: 9.43 * scale,
        vertical: 9.43 * scale,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.287 * scale),
          child: _buildProjectCard(scale, projects[index]),
        );
      },
    );
  }

  Widget _buildProjectCard(double scale, Map<String, dynamic> project) {
    final status = project['status'] as String;
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          _NoAnimationPageRoute(
            builder: (context) => ProjectDashboard(project: project),
          ),
        );
      },
      child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: bgGray100,
          width: 0.393 * scale,
        ),
        borderRadius: BorderRadius.circular(6.287 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 0.393 * scale),
            blurRadius: 1.179 * scale,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 0.393 * scale),
            blurRadius: 0.786 * scale,
            spreadRadius: -0.393 * scale,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.287 * scale),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Blue decorative circle in top right corner
            Positioned(
              right: -25.15 * scale,
              top: -25.15 * scale,
              child: Container(
                width: 50.296 * scale,
                height: 50.296 * scale,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryBlue.withOpacity(0.1),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(7.86 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          // Title and Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Name
                    Text(
                      project['name'],
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 6.287 * scale,
                        fontWeight: FontWeight.w400,
                        color: textDark,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(height: 2.358 * scale), // Increased gap
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 6.287 * scale,
                          color: textGray,
                        ),
                        SizedBox(width: 2.358 * scale),
                        Expanded(
                          child: Text(
                            project['location'],
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 5.501 * scale,
                              fontWeight: FontWeight.w400,
                              color: textGray,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.358 * scale), // Increased gap
                    // Manager
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 6.287 * scale,
                          color: textGray,
                        ),
                        SizedBox(width: 2.358 * scale),
                        Text(
                          project['manager'],
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 5.501 * scale,
                            fontWeight: FontWeight.w400,
                            color: textGray,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Status Badge
              _buildStatusBadge(scale, status),
            ],
          ),
          SizedBox(height: 5.501 * scale), // Increased gap
          // Progress Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.287 * scale,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF4A5565),
                ),
              ),
              _buildAnimatedProgressText(scale, project['progress']),
            ],
          ),
          SizedBox(height: 3.934 * scale), // Increased gap
          // Animated Progress Bar
          _buildAnimatedProgressBar(scale, project['progress']),
          SizedBox(height: 5.501 * scale), // Increased gap
          // Divider
          Container(
            height: 0.393 * scale,
            color: bgGray100,
          ),
          SizedBox(height: 0.787 * scale), // Increased gap
          // Start Date and Budget
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 6.287 * scale,
                    color: textGray,
                  ),
                  SizedBox(width: 2.358 * scale),
                  Text(
                    project['startDate'],
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.501 * scale,
                      fontWeight: FontWeight.w400,
                      color: textGray,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
              Text(
                project['budget'],
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.287 * scale,
                  fontWeight: FontWeight.w400,
                  color: textDark,
                ),
              ),
            ],
          ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildAnimatedProgressText(double scale, int targetProgress) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetProgress),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Text(
          '$value%',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 6.287 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
          ),
        );
      },
    );
  }

  Widget _buildAnimatedProgressBar(double scale, int targetProgress) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: targetProgress / 100.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Container(
          width: double.infinity,
          height: 3.144 * scale,
          decoration: BoxDecoration(
            color: progressBgLight,
            borderRadius: BorderRadius.circular(100),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: progressBg,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(double scale, String status) {
    Color bgColor;
    Color borderColor;
    Color textColor;
    String label;

    switch (status.toLowerCase()) {
      case 'active':
        bgColor = activeBadgeBg;
        borderColor = activeBadgeBorder;
        textColor = activeBadgeText;
        label = 'active';
        break;
      case 'completed':
        bgColor = completedBadgeBg;
        borderColor = completedBadgeBorder;
        textColor = completedBadgeText;
        label = 'completed';
        break;
      case 'draft':
        bgColor = draftBadgeBg;
        borderColor = draftBadgeBorder;
        textColor = draftBadgeText;
        label = 'draft';
        break;
      default:
        bgColor = activeBadgeBg;
        borderColor = activeBadgeBorder;
        textColor = activeBadgeText;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.537 * scale,
        vertical: 1.179 * scale,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: borderColor,
          width: 0.393 * scale,
        ),
        borderRadius: BorderRadius.circular(3.144 * scale),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Arimo',
          fontSize: 4.715 * scale,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildNewProjectButton(double scale) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 58.53 * scale,
        minHeight: 22.005 * scale,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [filterBlue, Color(0xFF1447E6), Color(0xFF432DD7)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: filterBlue.withOpacity(0.4),
            offset: Offset(0, 9.824 * scale),
            blurRadius: 19.647 * scale,
            spreadRadius: -4.715 * scale,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              _NoAnimationPageRoute(
                builder: (context) => const CreateNewProject(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 9.43 * scale,
              vertical: 7.07 * scale,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  size: 6.403 * scale,
                  color: Colors.white,
                ),
                SizedBox(width: 3.144 * scale),
                Flexible(
                  child: Text(
                    'New Project',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.501 * scale,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

