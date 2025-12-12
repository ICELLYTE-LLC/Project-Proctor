import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../Add New Member/addnewmember.dart';
import '../Projects/projects.dart';
import '../admin/settings.dart';
import '../admin/logout_dialog.dart';

// Custom page route with smooth fade animation (no slide, no navbar overlap)
class _ModalPageRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;

  _ModalPageRoute({required this.builder});

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 250);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: child,
    );
  }
}

// Custom page route with no animation for instant navigation (static nav bar)
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

class WelcomeDashboard extends StatefulWidget {
  const WelcomeDashboard({super.key});

  @override
  State<WelcomeDashboard> createState() => _WelcomeDashboardState();
}

class _WelcomeDashboardState extends State<WelcomeDashboard> {
  int _currentIndex = 2; // Dashboard is selected
  // Removed projects tab - only team members tab remains
  bool _isOnAddMemberPage = false; // Track if we're on add member page
  
  // Controllers for edit popup
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _navigateToAddMember() {
    Navigator.push(
      context,
      _ModalPageRoute(
        builder: (context) => const AddNewMember(),
      ),
    ).then((_) {
      // When returning from add member page
      setState(() {
        _isOnAddMemberPage = false;
        _currentIndex = 2; // Dashboard is selected
      });
    });
  }

  // Exact colors from Figma design
  static const Color primaryBlue = Color(0xFF2779F5);
  static const Color primaryBlueDark = Color(0xFF1D63D8);
  static const Color textDark = Color(0xFF101828);
  static const Color textGray = Color(0xFF6A7282);
  static const Color textLightGray = Color(0xFF99A1AF);
  static const Color borderGray = Color(0xFFF3F4F6);
  static const Color bgGray50 = Color(0xFFF9FAFB);
  static const Color bgGray200 = Color(0xFFE5E7EB);
  static const Color adminBadgeBg = Color(0xFFDBEAFE);
  static const Color adminBadgeBorder = Color(0xFFBEDBFF);
  static const Color adminBadgeText = Color(0xFF1447E6);
  static const Color clientBadgeBg = Color(0xFFF3E8FF);
  static const Color clientBadgeBorder = Color(0xFFE9D4FF);
  static const Color clientBadgeText = Color(0xFF8200DB);
  static const Color subcontractorBadgeBg = Color(0xFFFFEDD4);
  static const Color subcontractorBadgeBorder = Color(0xFFFFD6A7);
  static const Color subcontractorBadgeText = Color(0xFFCA3500);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Scale factor based on design width (167.417px in Figma)
    final scale = screenWidth / 167.417;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Extend body behind navigation bar
      extendBodyBehindAppBar: false,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        showRoleInsteadOfDashboard: _isOnAddMemberPage,
        onTap: (index) {
          if (index == 0) {
            // Projects button - navigate to Projects page
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const ProjectsPage(),
              ),
              (route) => false, // Remove all previous routes
            );
          } else if (index == 1) {
            // Role button - navigate to add member page
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const AddNewMember(),
              ),
              (route) => false, // Remove all previous routes
            );
          } else if (index == 2) {
            // Dashboard button - already on dashboard, do nothing
            return;
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
        child: Stack(
          children: [
            // Main content with gradient background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                  colors: [
                    bgGray50,
                    Colors.white,
                    const Color(0xFFEFF6FF).withOpacity(0.3),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 38.21 * scale + 9.454 * scale, // Header height + gap
                  left: 9.454 * scale,
                  right: 9.454 * scale,
                  bottom: 20 * scale,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metric Cards Grid (2x2)
                    _buildMetricCards(scale),
                    SizedBox(height: 9.454 * scale),
                    
                    // Recent Projects Section
                    _buildRecentProjects(scale),
                    SizedBox(height: 9.454 * scale),
                    
                    // Tabs and Team Members Section
                    _buildTabsAndTeamMembers(scale),
                  ],
                ),
              ),
            ),
            
            // Header
            _buildHeader(scale),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double scale) {
    return Container(
      height: 38.21 * scale,
      padding: EdgeInsets.symmetric(
        horizontal: 9.454 * scale,
        vertical: 9.454 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: borderGray,
            width: 0.394 * scale,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 18.908 * scale,
            height: 18.908 * scale,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryBlue, primaryBlueDark],
              ),
              borderRadius: BorderRadius.circular(6.303 * scale),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.25),
                  offset: Offset(0, 3.939 * scale),
                  blurRadius: 5.909 * scale,
                  spreadRadius: -1.182 * scale,
                ),
                BoxShadow(
                  color: primaryBlue.withOpacity(0.25),
                  offset: Offset(0, 1.576 * scale),
                  blurRadius: 2.364 * scale,
                  spreadRadius: -1.576 * scale,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/admin_dashboard_logo.png',
                width: 11.03 * scale,
                height: 11.03 * scale,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.03 * scale,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 4.727 * scale),
          
          // Title and greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Project Proctor',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.303 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Hi, Proctor',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 5.515 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray,
                    height: 1.43,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards(double scale) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 6.303 * scale,
      crossAxisSpacing: 6.303 * scale,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 71.1 / 66.97, // Exact Figma ratio: width 71.1 / height 66.97
      children: [
          _buildMetricCard(
            scale: scale,
            icon: Icons.folder,
            title: 'Active Projects',
            value: '12',
            subtitle: '+2 this month',
            iconBgColor: primaryBlue,
          ),
          _buildMetricCard(
            scale: scale,
            icon: Icons.people,
            title: 'Team Members',
            value: '47',
            subtitle: '+5 this month',
            iconBgColor: Colors.purple,
          ),
          _buildMetricCard(
            scale: scale,
            icon: Icons.account_balance_wallet,
            title: 'Total Budget',
            value: '\$8.5M',
            subtitle: 'Across all projects',
            iconBgColor: Colors.green,
          ),
          _buildMetricCard(
            scale: scale,
            icon: Icons.star,
            title: 'Completion Rate',
            value: '68%',
            subtitle: 'On track',
            iconBgColor: Colors.orange,
          ),
        ],
    );
  }

  Widget _buildMetricCard({
    required double scale,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconBgColor,
  }) {
    return Container(
      width: 71.1 * scale, // Exact Figma width
      height: 66.97 * scale, // Exact Figma height
      padding: EdgeInsets.all(8.27 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray,
          width: 0.394 * scale,
        ),
        borderRadius: BorderRadius.circular(6.3 * scale), // Exact Figma corner radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 1 * scale),
            blurRadius: 3 * scale,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 15.757 * scale,
            height: 15.757 * scale,
            decoration: BoxDecoration(
              gradient: iconBgColor == primaryBlue
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryBlue, primaryBlueDark],
                    )
                  : null,
              color: iconBgColor == primaryBlue ? null : iconBgColor,
              borderRadius: BorderRadius.circular(5.515 * scale),
            ),
            child: Icon(
              icon,
              size: 9.308 * scale,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.5 * scale), // Slightly reduced from 4.727
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 5.515 * scale,
              fontWeight: FontWeight.w400,
              color: textGray,
              height: 1.43,
            ),
          ),
          SizedBox(height: 1.4 * scale), // Slightly reduced from 1.576
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 9.454 * scale,
              fontWeight: FontWeight.w400,
              color: textDark,
              height: 1.33,
            ),
          ),
          SizedBox(height: 1.4 * scale), // Slightly reduced from 1.576
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 4.727 * scale,
              fontWeight: FontWeight.w400,
              color: textLightGray,
              height: 1.33,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProjects(double scale) {
    return Container(
      padding: EdgeInsets.all(8.272 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray,
          width: 0.394 * scale,
        ),
        borderRadius: BorderRadius.circular(6.303 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 1 * scale),
            blurRadius: 3 * scale,
            spreadRadius: 0,
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
                'Recent Projects',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.303 * scale,
                  fontWeight: FontWeight.w400,
                  color: textDark,
                  height: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    _NoAnimationPageRoute(
                      builder: (context) => const ProjectsPage(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 5.515 * scale,
                        fontWeight: FontWeight.w400,
                        color: primaryBlue,
                        height: 1.43,
                      ),
                    ),
                    SizedBox(width: 2.364 * scale),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 6.303 * scale,
                      color: primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.303 * scale),
          _buildProjectItem(scale, 'Riverside Office Complex', 68),
          SizedBox(height: 4.727 * scale),
          _buildProjectItem(scale, 'Downtown Retail Center', 45),
          SizedBox(height: 4.727 * scale),
          _buildProjectItem(scale, 'Parkview Apartments', 92),
        ],
      ),
    );
  }

  Widget _buildProjectItem(double scale, String name, int percentage) {
    return Container(
      height: 28.362 * scale,
      padding: EdgeInsets.all(6.3 * scale),
      decoration: BoxDecoration(
        color: bgGray50,
        borderRadius: BorderRadius.circular(5.515 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.303 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.515 * scale,
                  fontWeight: FontWeight.w400,
                  color: primaryBlue,
                  height: 1.43,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.151 * scale),
          ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Stack(
              children: [
                Container(
                  height: 3.151 * scale,
                  width: double.infinity,
                  color: bgGray200,
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    height: 3.151 * scale,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primaryBlue, primaryBlueDark],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsAndTeamMembers(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tabs - Clickable with state management
        Container(
          height: 14.181 * scale,
          constraints: BoxConstraints(maxWidth: 116.859 * scale),
          padding: EdgeInsets.all(1.18 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFFECECF0),
            borderRadius: BorderRadius.circular(5.515 * scale),
          ),
          child: Row(
            children: [
              // Team Members Tab - only tab now
              Expanded(
                child: Container(
                  height: 11.424 * scale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.515 * scale),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 6.303 * scale,
                        color: textDark,
                      ),
                      SizedBox(width: 3.15 * scale),
                      Flexible(
                        child: Text(
                          'Team Members',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 5.515 * scale,
                            fontWeight: FontWeight.w400,
                            color: textDark,
                            height: 1.43,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.151 * scale),
        
        // Team Members Content
        _buildTeamMembersContent(scale),
      ],
    );
  }

  Widget _buildTeamMembersContent(double scale) {
    return Container(
      padding: EdgeInsets.all(9.454 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team Members',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 7.878 * scale,
                        fontWeight: FontWeight.w400,
                        color: textDark,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 1.576 * scale),
                    Text(
                      'Manage your team and their access',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 6.303 * scale,
                        fontWeight: FontWeight.w400,
                        color: textGray,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.727 * scale),
              Flexible(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _navigateToAddMember();
                    },
                    borderRadius: BorderRadius.circular(5.515 * scale),
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.2),
                    child: Ink(
                      height: 14.181 * scale,
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.73 * scale,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryBlue, primaryBlueDark],
                        ),
                        borderRadius: BorderRadius.circular(5.515 * scale),
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.25),
                            offset: Offset(0, 3.939 * scale),
                            blurRadius: 5.909 * scale,
                            spreadRadius: -1.182 * scale,
                          ),
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.25),
                            offset: Offset(0, 1.576 * scale),
                            blurRadius: 2.364 * scale,
                            spreadRadius: -1.576 * scale,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 6.303 * scale,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2.364 * scale),
                          Flexible(
                            child: Text(
                              'Add Member',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 5.515 * scale,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 1.43,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 9.454 * scale),
          
          // Team Member Cards
          _buildTeamMemberCard(
            scale,
            name: 'Sarah',
            email: '@sarah.j@example.com',
            project: 'All',
            role: 'admin',
            icon: Icons.shield,
          ),
          SizedBox(height: 4.727 * scale),
          _buildTeamMemberCard(
            scale,
            name: 'Mich',
            email: '@michael.b@example.com',
            project: 'Riverwick',
            role: 'client',
            icon: Icons.person,
          ),
          SizedBox(height: 4.727 * scale),
          _buildTeamMemberCard(
            scale,
            name: 'John',
            email: '@john.m@example.com',
            project: 'Riverwick',
            role: 'subcontractor',
            icon: Icons.construction,
          ),
          SizedBox(height: 4.727 * scale),
          _buildTeamMemberCard(
            scale,
            name: 'Lisa',
            email: '@lisa.c@example.com',
            project: 'Dowellon',
            role: 'subcontractor',
            icon: Icons.construction,
          ),
          SizedBox(height: 4.727 * scale),
          _buildTeamMemberCard(
            scale,
            name: 'Robert',
            email: '@robert.j@example.com',
            project: 'Riverwick',
            role: 'subcontractor',
            icon: Icons.construction,
          ),
        ],
      ),
    );
  }


  Widget _buildTeamMemberCard(
    double scale, {
    required String name,
    required String email,
    required String project,
    required String role,
    required IconData icon,
  }) {
    Color badgeBg;
    Color badgeBorder;
    Color badgeText;

    switch (role) {
      case 'admin':
        badgeBg = adminBadgeBg;
        badgeBorder = adminBadgeBorder;
        badgeText = adminBadgeText;
        break;
      case 'client':
        badgeBg = clientBadgeBg;
        badgeBorder = clientBadgeBorder;
        badgeText = clientBadgeText;
        break;
      default: // subcontractor
        badgeBg = subcontractorBadgeBg;
        badgeBorder = subcontractorBadgeBorder;
        badgeText = subcontractorBadgeText;
    }

    return Container(
      width: double.infinity, // Match Recent Projects card width
      padding: EdgeInsets.all(6.697 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGray,
          width: 0.394 * scale,
        ),
        borderRadius: BorderRadius.circular(6.303 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 1 * scale),
            blurRadius: 3 * scale,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 18.908 * scale,
            height: 18.908 * scale,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryBlue, primaryBlueDark],
              ),
              borderRadius: BorderRadius.circular(5.515 * scale),
            ),
            child: Icon(
              icon,
              size: 9.454 * scale,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 6.303 * scale),
          
          // Info section - Vertical layout: Tag, Name, Project (no email)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tag first
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.545 * scale,
                    vertical: 1.182 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    border: Border.all(
                      color: badgeBorder,
                      width: 0.394 * scale,
                    ),
                    borderRadius: BorderRadius.circular(3.151 * scale),
                  ),
                  child: Text(
                    role == 'subcontractor' ? 'SUBCON' : role.toUpperCase(),
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 4.727 * scale,
                      fontWeight: FontWeight.w400,
                      color: badgeText,
                      height: 1.33,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
                SizedBox(height: 1.576 * scale),
                // Name
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.303 * scale,
                    fontWeight: FontWeight.w400,
                    color: textDark,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 1.576 * scale),
                // Project
                Text(
                  'Project: $project',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 4.727 * scale,
                    fontWeight: FontWeight.w400,
                    color: textLightGray,
                    height: 1.33,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 3.151 * scale), // Reduced spacing
          
          // Action buttons - All roles have view, edit, and delete icons
          // TO REPLACE ICONS: Replace the icon files in assets/icons/ folder:
          // - view_icon.png: Link/view icon (chain/link icon)
          // - edit_icon.png: Edit icon (pencil icon)
          // - delete_icon.png: Delete icon (trash icon)
          // Make sure the new icons are PNG format and have transparent backgrounds
          SizedBox(
            width: (14.181 * 3 + 3.151 * 2) * scale, // 3 buttons + 2 gaps for all roles
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  scale,
                  'assets/icons/view_icon.png',
                  name: name,
                  role: role,
                  project: project,
                ),
                SizedBox(width: 3.151 * scale),
                _buildActionButton(
                  scale,
                  'assets/icons/edit_icon.png',
                  name: name,
                  role: role,
                  project: project,
                ),
                SizedBox(width: 3.151 * scale),
                _buildActionButton(
                  scale,
                  'assets/icons/delete_icon.png',
                  name: name,
                  role: role,
                  project: project,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds an action button with an icon
  /// 
  /// TO REPLACE ICONS:
  /// 1. Place your icon files in the assets/icons/ folder
  /// 2. Supported formats: PNG (recommended), JPG, SVG (if using flutter_svg package)
  /// 3. Recommended size: 24x24 pixels or higher for better quality
  /// 4. Use transparent backgrounds for better visual integration
  /// 5. Update the iconPath parameter to point to your new icon file
  /// 
  /// Example:
  /// - Replace 'assets/icons/view_icon.png' with 'assets/icons/my_view_icon.png'
  /// - Make sure the file exists in the assets/icons/ directory
  /// - Update pubspec.yaml if adding new asset paths
  void _showMemberDetailsPopup(
    BuildContext context,
    double scale, {
    required String name,
    required String role,
    required String project,
  }) {
    // Generate invite code (placeholder - will come from database later)
    // Format: PROJ123-ROLE-XXXX
    String rolePrefix = role.toUpperCase().substring(0, role.length > 6 ? 6 : role.length);
    String inviteCode = 'PROJ123-$rolePrefix-${_generateRandomCode()}';
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Dark overlay
      builder: (BuildContext context) {
        return _buildMemberDetailsDialog(scale, name, role, project, inviteCode);
      },
    );
  }

  String _generateRandomCode() {
    // Generate random alphanumeric code (will be from database later)
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(4, (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length]).join();
  }

  Widget _buildMemberDetailsDialog(
    double scale,
    String name,
    String role,
    String project,
    String inviteCode,
  ) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10.632 * scale),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 145.808 * scale),
        padding: EdgeInsets.all(9.11 * scale),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE5E7EB), // Gray-200 border color for stroke
            width: 0.38 * scale,
          ),
          borderRadius: BorderRadius.circular(3.797 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 3.797 * scale),
              blurRadius: 5.696 * scale,
              spreadRadius: -1.139 * scale,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 1.519 * scale),
              blurRadius: 2.278 * scale,
              spreadRadius: -1.519 * scale,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Member Details',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 6.835 * scale,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                          height: 1.55,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 3.038 * scale),
                      Text(
                        'View member information and invite code',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 5.316 * scale,
                          fontWeight: FontWeight.w400,
                          color: textGray,
                          height: 1.43,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(3.038 * scale),
                    child: Container(
                      width: 6.075 * scale,
                      height: 6.075 * scale,
                      padding: EdgeInsets.all(1.519 * scale),
                      child: Icon(
                        Icons.close,
                        size: 6.075 * scale,
                        color: textGray.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.075 * scale), // Increased gap between subtitle and cards
            
            // Name field
            _buildDetailField(
              scale,
              label: 'Name',
              value: name,
            ),
            SizedBox(height: 4.556 * scale),
            
            // Role field
            _buildDetailField(
              scale,
              label: 'Role',
              value: role.toUpperCase(),
            ),
            SizedBox(height: 4.556 * scale),
            
            // Assigned Projects field
            _buildDetailField(
              scale,
              label: 'Assigned Projects',
              value: project,
            ),
            SizedBox(height: 4.556 * scale),
            
            // Invite Code section (special blue background)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.936 * scale),
              decoration: BoxDecoration(
                color: adminBadgeBg, // Light blue background
                border: Border.all(
                  color: adminBadgeBorder,
                  width: 0.38 * scale,
                ),
                borderRadius: BorderRadius.circular(5.316 * scale),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Custom invite icon from assets
                      Image.asset(
                        'assets/icons/invite_icon.png',
                        width: 4.556 * scale,
                        height: 4.556 * scale,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback to Material icon if image not found
                          return Icon(
                            Icons.link,
                            size: 4.556 * scale,
                            color: primaryBlue,
                          );
                        },
                      ),
                      SizedBox(width: 3.038 * scale),
                      Text(
                        'Invite Code',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 4.556 * scale,
                          fontWeight: FontWeight.w400,
                          color: primaryBlue,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.519 * scale),
                  Text(
                    inviteCode,
                    style: TextStyle(
                      fontFamily: 'Cousine', // Monospace font for code
                      fontSize: 5.316 * scale,
                      fontWeight: FontWeight.w400,
                      color: textDark,
                      height: 1.43,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 1.519 * scale),
                  Text(
                    'Share this code with $name',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 4.556 * scale,
                      fontWeight: FontWeight.w400,
                      color: textGray,
                      height: 1.33,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.556 * scale),
            
            // Close button with pressing effect
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(3.797 * scale),
                splashColor: Colors.white.withOpacity(0.3), // White splash effect
                highlightColor: Colors.white.withOpacity(0.2), // White highlight effect
                child: Ink(
                  width: double.infinity,
                  height: 13.669 * scale,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [primaryBlue, primaryBlueDark],
                    ),
                    borderRadius: BorderRadius.circular(3.797 * scale),
                  ),
                  child: Center(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: 5.316 * scale,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.43,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(double scale, {required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.936 * scale),
      decoration: BoxDecoration(
        color: bgGray50,
        border: Border.all(
          color: const Color(0xFFE5E7EB), // Gray-200 border color for stroke
          width: 0.38 * scale,
        ),
        borderRadius: BorderRadius.circular(5.316 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 4.556 * scale,
              fontWeight: FontWeight.w400,
              color: textGray,
              height: 1.33,
            ),
          ),
          SizedBox(height: 1.519 * scale),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 5.316 * scale,
              fontWeight: FontWeight.w400,
              color: textDark,
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(double scale, String iconPath, {String? name, String? role, String? project}) {
    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (iconPath.contains('view_icon') && name != null && role != null && project != null) {
              _showMemberDetailsPopup(
                context,
                scale,
                name: name,
                role: role,
                project: project,
              );
            } else if (iconPath.contains('edit_icon') && name != null && role != null && project != null) {
              // Generate email from name if not available
              String email = '@${name.toLowerCase().replaceAll(' ', '.')}@example.com';
              _showEditMemberPopup(
                context,
                scale,
                name: name,
                email: email,
                role: role,
                currentProject: project,
              );
            } else if (iconPath.contains('delete_icon') && name != null && role != null) {
              // Generate email from name if not available
              String email = '@${name.toLowerCase().replaceAll(' ', '.')}@example.com';
              _showDeleteMemberPopup(
                context,
                scale,
                name: name,
                email: email,
                role: role,
              );
            }
          },
          borderRadius: BorderRadius.circular(3.151 * scale),
          child: Container(
            width: 14.181 * scale,
            height: 12.605 * scale,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.151 * scale),
            ),
            child: Image.asset(
              iconPath,
              width: 6.303 * scale,
              height: 6.303 * scale,
              // Removed color parameter to show original icon colors from assets
              // If you want to tint icons, uncomment the line below and set your desired color
              // color: textGray,
              errorBuilder: (context, error, stackTrace) {
                // Fallback icon if the image file is not found
                return Icon(
                  Icons.help_outline,
                  size: 6.303 * scale,
                  color: textGray,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showEditMemberPopup(
    BuildContext context,
    double scale, {
    required String name,
    required String email,
    required String role,
    required String currentProject,
  }) {
    // Initialize controllers with current values
    _nameController.text = name;
    // Extract email from the format '@email@example.com' or use provided email
    _emailController.text = email.startsWith('@') ? email.substring(1) : email;
    
    // List of all available projects
    final List<String> allProjects = [
      'Riverside Office Complex',
      'Downtown Retail Center',
      'Parkview Apartments',
      'Highland Medical Facility',
      'Westside Shopping Center',
    ];
    
    // Initialize state variables that persist across rebuilds
    final Set<String> assignedProjects = {currentProject};
    bool showMoreProjects = false;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Dark overlay
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10.632 * scale),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 145.745 * scale),
                padding: EdgeInsets.all(9.11 * scale),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 0.38 * scale,
                  ),
                  borderRadius: BorderRadius.circular(3.797 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 3.797 * scale),
                      blurRadius: 5.696 * scale,
                      spreadRadius: -1.139 * scale,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0, 1.519 * scale),
                      blurRadius: 2.278 * scale,
                      spreadRadius: -1.519 * scale,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Edit Member',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 6.832 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                  height: 1.556, // 10.627 / 6.832
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 3.038 * scale),
                              Text(
                                'Update member information',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 5.314 * scale,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF717182), // Exact Figma color
                                  height: 1.429, // 7.591 / 5.314
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(3.038 * scale),
                            child: Container(
                              width: 6.075 * scale,
                              height: 6.075 * scale,
                              padding: EdgeInsets.all(1.519 * scale),
                              child: Icon(
                                Icons.close,
                                size: 6.075 * scale,
                                color: textGray.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.038 * scale), // Gap from header to content
                    
                    // Name field (editable)
                    _buildEditableField(
                      scale,
                      label: 'Name',
                      controller: _nameController,
                    ),
                    SizedBox(height: 4.556 * scale), // Gap between fields
                    
                    // Email field (editable)
                    _buildEditableField(
                      scale,
                      label: 'Email',
                      controller: _emailController,
                    ),
                    SizedBox(height: 4.556 * scale), // Gap between fields
                    
                    // Assigned Projects section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assigned Projects',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 4.556 * scale,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4A5565),
                            height: 1.333, // 6.073 / 4.556
                          ),
                        ),
                        SizedBox(height: 2.277 * scale), // Gap from label to container
                        // Projects list container with modern chip design
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(5.314 * scale),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFFE5E7EB).withOpacity(0.5),
                              width: 0.76 * scale,
                            ),
                            borderRadius: BorderRadius.circular(5.314 * scale),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                offset: Offset(0, 1.519 * scale),
                                blurRadius: 4.556 * scale,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 3.036 * scale,
                                runSpacing: 3.036 * scale,
                                children: (showMoreProjects ? allProjects : allProjects.take(3).toList()).map((project) {
                                  final isSelected = assignedProjects.contains(project);
                                  
                                  return TweenAnimationBuilder<double>(
                                    tween: Tween(begin: isSelected ? 1.0 : 0.0, end: isSelected ? 1.0 : 0.0),
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    builder: (context, value, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              assignedProjects.remove(project);
                                            } else {
                                              assignedProjects.add(project);
                                            }
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5.314 * scale,
                                            vertical: 3.797 * scale,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: isSelected
                                                ? const LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [primaryBlue, primaryBlueDark],
                                                  )
                                                : null,
                                            color: isSelected ? null : bgGray50,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.transparent
                                                  : const Color(0xFFE5E7EB).withOpacity(0.6),
                                              width: 0.76 * scale,
                                            ),
                                            borderRadius: BorderRadius.circular(4.556 * scale),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: primaryBlue.withOpacity(0.3),
                                                      offset: Offset(0, 1.519 * scale),
                                                      blurRadius: 3.797 * scale,
                                                      spreadRadius: -1.139 * scale,
                                                    ),
                                                    BoxShadow(
                                                      color: primaryBlue.withOpacity(0.2),
                                                      offset: Offset(0, 0.76 * scale),
                                                      blurRadius: 2.277 * scale,
                                                      spreadRadius: -0.38 * scale,
                                                    ),
                                                  ]
                                                : [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.02),
                                                      offset: Offset(0, 1.139 * scale),
                                                      blurRadius: 1.519 * scale,
                                                      spreadRadius: 0,
                                                    ),
                                                  ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                width: 4.556 * scale,
                                                height: 4.556 * scale,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: isSelected ? Colors.white : Colors.transparent,
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Colors.white
                                                        : textGray.withOpacity(0.4),
                                                    width: 0.95 * scale,
                                                  ),
                                                  borderRadius: BorderRadius.circular(1.139 * scale),
                                                ),
                                                child: isSelected
                                                    ? Icon(
                                                        Icons.check,
                                                        size: 3.036 * scale,
                                                        color: primaryBlue,
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(width: 2.658 * scale),
                                              Text(
                                                project,
                                                style: TextStyle(
                                                  fontFamily: 'Arimo',
                                                  fontSize: 4.556 * scale,
                                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                  color: isSelected ? Colors.white : textDark,
                                                  height: 1.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              if (!showMoreProjects && allProjects.length > 3)
                                Padding(
                                  padding: EdgeInsets.only(top: 3.036 * scale),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showMoreProjects = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.314 * scale,
                                        vertical: 3.036 * scale,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryBlue.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(3.797 * scale),
                                        border: Border.all(
                                          color: primaryBlue.withOpacity(0.2),
                                          width: 0.76 * scale,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.expand_more,
                                            size: 4.556 * scale,
                                            color: primaryBlue,
                                          ),
                                          SizedBox(width: 2.277 * scale),
                                          Text(
                                            'Show ${allProjects.length - 3} more projects',
                                            style: TextStyle(
                                              fontFamily: 'Arimo',
                                              fontSize: 4.556 * scale,
                                              fontWeight: FontWeight.w500,
                                              color: primaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.277 * scale),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 3.797 * scale,
                              color: textLightGray,
                            ),
                            SizedBox(width: 1.519 * scale),
                            Text(
                              '${assignedProjects.length} assigned',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 4.556 * scale,
                                fontWeight: FontWeight.w400,
                                color: textLightGray,
                                height: 1.333, // 6.073 / 4.556
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 4.556 * scale),
                    
                    // Save Changes button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // TODO: Save changes to database
                          Navigator.of(context).pop(); // Close edit dialog
                          // Show success animation
                          _showSuccessAnimation(context, scale);
                        },
                        borderRadius: BorderRadius.circular(3.797 * scale),
                        splashColor: Colors.white.withOpacity(0.3),
                        highlightColor: Colors.white.withOpacity(0.2),
                        child: Ink(
                          width: double.infinity,
                          height: 13.669 * scale,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [primaryBlue, primaryBlueDark],
                            ),
                            borderRadius: BorderRadius.circular(3.797 * scale),
                          ),
                          child: Center(
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 5.316 * scale,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                height: 1.43,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEditableField(double scale, {required String label, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 4.556 * scale,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF4A5565),
            height: 1.333, // 6.073 / 4.556
          ),
        ),
        SizedBox(height: 2.277 * scale), // Gap from label to input
        Container(
          width: double.infinity,
          height: 13.664 * scale, // Exact Figma height
          padding: EdgeInsets.symmetric(
            horizontal: 4.556 * scale,
            vertical: 1.519 * scale,
          ),
          decoration: BoxDecoration(
            color: bgGray50,
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 0.38 * scale,
            ),
            borderRadius: BorderRadius.circular(3.797 * scale),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 5.314 * scale, // Exact Figma size
              fontWeight: FontWeight.w400,
              color: textDark, // #101828
              height: 1.429, // 7.591 / 5.314
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }


  void _showDeleteMemberPopup(
    BuildContext context,
    double scale, {
    required String name,
    required String email,
    required String role,
  }) {
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

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return Dialog(
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
                          'Delete Member',
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
                        onTap: () => Navigator.of(context).pop(),
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
                // Subtitle message
                Text(
                  'This action cannot be undone',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: messageFontSize,
                    color: const Color(0xFF6E6E6E),
                    height: 1.4,
                  ),
                ),
                SizedBox(height: spacing1),
                // Red confirmation box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(dialogPadding * 0.4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2), // red-50
                    border: Border.all(
                      color: const Color(0xFFFFC9C9), // red-200 border
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(buttonBorderRadius * 0.8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete $name?',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: messageFontSize,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF82181A), // red-900
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: spacing1 * 0.3),
                      Text(
                        '${role.toLowerCase()} • ${email.startsWith('@') ? email.substring(1) : email}',
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: messageFontSize * 0.9,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFE7000B), // red-600
                          height: 1.4,
                        ),
                      ),
                    ],
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
                            Navigator.of(context).pop();
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
                          onPressed: () {
                            // TODO: Delete member from database
                            Navigator.of(context).pop(); // Close delete confirmation dialog
                            // Show delete success animation
                            _showDeleteSuccessAnimation(context, scale);
                            // TODO: Update team member list after deletion
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
        );
      },
    );
  }

  void _showSuccessAnimation(BuildContext context, double scale) {
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
                    color: primaryBlue.withOpacity(0.1),
                    blurRadius: 15 * scale,
                    spreadRadius: 2 * scale,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Beautiful animated success icon with theme colors
                  _buildAnimatedSuccessIcon(scale),
                  SizedBox(height: 10 * scale),
                  Text(
                    'Member Updated!',
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
                    'The team member has been\nsuccessfully updated',
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
                            colors: [primaryBlue, primaryBlueDark],
                          ),
                          borderRadius: BorderRadius.circular(5.508 * scale),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBlue.withOpacity(0.3),
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

  Widget _buildAnimatedSuccessIcon(double scale) {
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
        
        return SizedBox(
          width: 65 * scale,
          height: 65 * scale,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Outer pulsing circle - largest with rotation
              Transform.rotate(
                angle: rotation * 0.5 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.25).clamp(0.0, 1.3),
                  child: Container(
                    width: 65 * scale,
                    height: 65 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withOpacity(outerOpacity),
                    ),
                  ),
                ),
              ),
              // Middle pulsing circle with rotation
              Transform.rotate(
                angle: -rotation * 0.3 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.15).clamp(0.0, 1.2),
                  child: Container(
                    width: 55 * scale,
                    height: 55 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withOpacity(middleOpacity),
                    ),
                  ),
                ),
              ),
              // Inner circle with rotation
              Transform.rotate(
                angle: rotation * 0.2 * 3.14159 / 180,
                child: Transform.scale(
                  scale: (value * 1.08).clamp(0.0, 1.1),
                  child: Container(
                    width: 45 * scale,
                    height: 45 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue.withOpacity(innerOpacity),
                    ),
                  ),
                ),
              ),
              // Main circle with check - theme blue gradient (no rotation, just scale)
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
                      colors: [primaryBlue, primaryBlueDark],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.6),
                        blurRadius: 12 * scale,
                        spreadRadius: 5 * scale,
                      ),
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.4),
                        blurRadius: 8 * scale,
                        spreadRadius: 2 * scale,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
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
                    'Member Deleted!',
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
                    'The team member has been\nsuccessfully deleted',
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

