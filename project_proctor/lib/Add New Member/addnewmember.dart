import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../Welcome Dashboard/welcomedashboard.dart';
import '../Projects/projects.dart';
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

class AddNewMember extends StatefulWidget {
  const AddNewMember({super.key});

  @override
  State<AddNewMember> createState() => _AddNewMemberState();
}

class _AddNewMemberState extends State<AddNewMember> {
  int _currentIndex = 2; // Role is selected (center button shows role when on this page, index 2 when showRoleInsteadOfDashboard is true)
  bool _isOnAddMemberPage = true; // Track that we're on add member page
  
  // Controllers for form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  
  // State variables
  String _selectedRole = 'Client';
  bool _obscurePassword = true;
  Set<String> _selectedProjects = {};
  bool _showMoreProjects = false;
  
  // List of all available projects
  final List<String> _allProjects = [
    'Riverside Office Complex',
    'Downtown Retail Center',
    'Parkview Apartments',
    'Highland Medical Facility',
    'Westside Shopping Center',
  ];
  
  // Role options
  final List<String> _roles = ['Client', 'Subcontractor', 'Admin'];
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  // Exact colors from Figma design
  static const Color primaryBlue = Color(0xFF2779F5);
  static const Color primaryBlueDark = Color(0xFF1D63D8);
  static const Color textDark = Color(0xFF101828);
  static const Color textGray = Color(0xFF6A7282);
  static const Color textLightGray = Color(0xFF99A1AF);
  static const Color bgGray50 = Color(0xFFF9FAFB);
  static const Color bgGray200 = Color(0xFFE5E7EB);
  static const Color inputBg = Color(0xFFF3F3F5);

  String _generateInviteCode() {
    // Generate random alphanumeric code (will be from database later)
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String rolePrefix = _selectedRole.toUpperCase().substring(0, _selectedRole.length > 6 ? 6 : _selectedRole.length);
    String randomCode = List.generate(4, (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length]).join();
    return 'PROJ123-$rolePrefix-$randomCode';
  }


  void _generateCode() {
    setState(() {
      _inviteCodeController.text = _generateInviteCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Scale factor based on design width (167.213px in Figma)
    final scale = screenWidth / 167.213;

    return PopScope(
      canPop: Navigator.of(context).canPop(),
      onPopInvoked: (didPop) {
        // Handle back button - if pop was prevented and we can pop, do it safely
        if (!didPop) {
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
          }
        }
      },
      child: Scaffold(
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
            // Dashboard button (index 1) - navigate back if we came from a dashboard page
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              // If we can't pop, navigate to WelcomeDashboard
              Navigator.of(context).pushAndRemoveUntil(
                _NoAnimationPageRoute(
                  builder: (context) => const WelcomeDashboard(),
                ),
                (route) => false,
              );
            }
          } else if (index == 2) {
            // Center button is role button when on add member page - already here
            // Do nothing
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
        child: Container(
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
            padding: EdgeInsets.symmetric(
              horizontal: 9.443 * scale,
              vertical: 18.89 * scale,
            ),
            child: Column(
              children: [
                // Main card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.984 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: bgGray200,
                      width: 0.393 * scale,
                    ),
                    borderRadius: BorderRadius.circular(9.443 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: Offset(0, 4.721 * scale),
                        blurRadius: 11.802 * scale,
                        spreadRadius: -2.361 * scale,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        offset: Offset(0, 1.574 * scale),
                        blurRadius: 3.148 * scale,
                        spreadRadius: -1.574 * scale,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with icon
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 31.475 * scale,
                              height: 31.475 * scale,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [primaryBlue, primaryBlueDark],
                                ),
                                borderRadius: BorderRadius.circular(6.295 * scale),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryBlue.withOpacity(0.3),
                                    offset: Offset(0, 3.934 * scale),
                                    blurRadius: 5.902 * scale,
                                    spreadRadius: -1.18 * scale,
                                  ),
                                  BoxShadow(
                                    color: primaryBlue.withOpacity(0.3),
                                    offset: Offset(0, 1.574 * scale),
                                    blurRadius: 2.361 * scale,
                                    spreadRadius: -1.574 * scale,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person_add,
                                size: 15.738 * scale,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 12.59 * scale),
                            Text(
                              'Add New Member',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 6.295 * scale,
                                fontWeight: FontWeight.w400,
                                color: textDark,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 3.148 * scale),
                            Text(
                              'Create a new team member account',
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 6.295 * scale,
                                fontWeight: FontWeight.w400,
                                color: textGray,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.59 * scale),
                      
                      // Form fields
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Full Name
                          _buildTextField(
                            scale,
                            label: 'Full Name *',
                            controller: _fullNameController,
                            hint: 'John Doe',
                          ),
                          SizedBox(height: 7.869 * scale),
                          
                          // Email
                          _buildEmailField(scale),
                          SizedBox(height: 7.869 * scale),
                          
                          // Password
                          _buildPasswordField(scale),
                          SizedBox(height: 7.869 * scale),
                          
                          // Role
                          _buildRoleField(scale),
                          SizedBox(height: 7.869 * scale),
                          
                          // Select Projects
                          _buildProjectsField(scale),
                          SizedBox(height: 7.869 * scale),
                          
                          // Invite Code
                          _buildInviteCodeField(scale),
                          SizedBox(height: 12.59 * scale),
                          
                          // Add Member button
                          _buildAddMemberButton(scale),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildTextField(
    double scale, {
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.508 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.0,
          ),
        ),
        SizedBox(height: 3.148 * scale),
        Container(
          width: double.infinity,
          height: 18.885 * scale,
          padding: EdgeInsets.symmetric(
            horizontal: 4.721 * scale,
            vertical: 0,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: inputBg,
            border: Border.all(
              color: Colors.transparent,
              width: 0.393 * scale,
            ),
            borderRadius: BorderRadius.circular(5.508 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                offset: Offset(0, 1.574 * scale),
                blurRadius: 3.148 * scale,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 6.295 * scale,
              fontWeight: FontWeight.w400,
              color: textDark,
              height: 1.0,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.295 * scale,
                color: const Color(0xFF717182),
                height: 1.0,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 1.574 * scale,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email *',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.508 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.0,
          ),
        ),
        SizedBox(height: 3.148 * scale),
        Container(
          width: double.infinity,
          height: 18.885 * scale,
          padding: EdgeInsets.symmetric(
            horizontal: 4.721 * scale,
            vertical: 0,
          ),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: inputBg,
            border: Border.all(
              color: Colors.transparent,
              width: 0.393 * scale,
            ),
            borderRadius: BorderRadius.circular(5.508 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                offset: Offset(0, 1.574 * scale),
                blurRadius: 3.148 * scale,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: 6.295 * scale,
              fontWeight: FontWeight.w400,
              color: textDark,
              height: 1.0,
            ),
            decoration: InputDecoration(
              hintText: 'john.doe@example.com',
              hintStyle: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 6.295 * scale,
                color: const Color(0xFF717182),
                height: 1.0,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 1.574 * scale,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.148 * scale),
        Text(
          'This email must not be registered yet',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 4.721 * scale,
            fontWeight: FontWeight.w400,
            color: textLightGray,
            height: 1.33,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password *',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.508 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.0,
          ),
        ),
        SizedBox(height: 3.148 * scale),
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 18.885 * scale,
              padding: EdgeInsets.only(
                left: 4.721 * scale,
                right: 18.885 * scale,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: inputBg,
                border: Border.all(
                  color: Colors.transparent,
                  width: 0.393 * scale,
                ),
                borderRadius: BorderRadius.circular(5.508 * scale),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.295 * scale,
                  fontWeight: FontWeight.w400,
                  color: textDark,
                  height: 1.0,
                ),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.295 * scale,
                    color: const Color(0xFF717182),
                    height: 1.0,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 1.574 * scale,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 5.51 * scale,
              top: 5.51 * scale,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                child: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 7.869 * scale,
                  color: textGray,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleField(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role *',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.508 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.0,
          ),
        ),
        SizedBox(height: 3.148 * scale),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(9.443 * scale),
                ),
              ),
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(12.984 * scale),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _roles.map((role) {
                      return ListTile(
                        title: Text(
                          role,
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 5.508 * scale,
                            color: textDark,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedRole = role;
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
          child:             Container(
              width: double.infinity,
              height: 14.164 * scale,
              padding: EdgeInsets.symmetric(
                horizontal: 5.114 * scale,
              ),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: inputBg,
                border: Border.all(
                  color: Colors.transparent,
                  width: 0.393 * scale,
                ),
                borderRadius: BorderRadius.circular(5.508 * scale),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _selectedRole,
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 5.508 * scale,
                      fontWeight: FontWeight.w400,
                      color: textDark,
                      height: 1.0,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 6.295 * scale,
                    color: textDark,
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }

  Widget _buildProjectsField(double scale) {
    final visibleProjects = _showMoreProjects ? _allProjects : _allProjects.take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Projects * (Multiple allowed)',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 5.508 * scale,
            fontWeight: FontWeight.w400,
            color: textDark,
            height: 1.0,
          ),
        ),
        SizedBox(height: 3.148 * scale),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(7.869 * scale),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: bgGray200.withOpacity(0.5),
              width: 0.787 * scale,
            ),
            borderRadius: BorderRadius.circular(7.869 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                offset: Offset(0, 2.361 * scale),
                blurRadius: 6.295 * scale,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 4.721 * scale,
                runSpacing: 4.721 * scale,
                children: visibleProjects.map((project) {
                  final isSelected = _selectedProjects.contains(project);
                  
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: isSelected ? 1.0 : 0.0, end: isSelected ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedProjects.remove(project);
                            } else {
                              _selectedProjects.add(project);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            horizontal: 7.869 * scale,
                            vertical: 5.508 * scale,
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
                                  : bgGray200.withOpacity(0.6),
                              width: 0.787 * scale,
                            ),
                            borderRadius: BorderRadius.circular(6.295 * scale),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.3),
                                      offset: Offset(0, 2.361 * scale),
                                      blurRadius: 4.721 * scale,
                                      spreadRadius: -1.574 * scale,
                                    ),
                                    BoxShadow(
                                      color: primaryBlue.withOpacity(0.2),
                                      offset: Offset(0, 1.574 * scale),
                                      blurRadius: 3.148 * scale,
                                      spreadRadius: -0.787 * scale,
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      offset: Offset(0, 1.574 * scale),
                                      blurRadius: 2.361 * scale,
                                      spreadRadius: 0,
                                    ),
                                  ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 5.902 * scale,
                                height: 5.902 * scale,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.white
                                        : textGray.withOpacity(0.4),
                                    width: 1.18 * scale,
                                  ),
                                  borderRadius: BorderRadius.circular(1.574 * scale),
                                ),
                                child: isSelected
                                    ? Icon(
                                        Icons.check,
                                        size: 3.934 * scale,
                                        color: primaryBlue,
                                      )
                                    : null,
                              ),
                              SizedBox(width: 3.934 * scale),
                              Text(
                                project,
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 5.902 * scale,
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
              if (!_showMoreProjects && _allProjects.length > 3)
                Padding(
                  padding: EdgeInsets.only(top: 4.721 * scale),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showMoreProjects = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.869 * scale,
                        vertical: 4.721 * scale,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5.508 * scale),
                        border: Border.all(
                          color: primaryBlue.withOpacity(0.2),
                          width: 0.787 * scale,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.expand_more,
                            size: 5.902 * scale,
                            color: primaryBlue,
                          ),
                          SizedBox(width: 3.148 * scale),
                          Text(
                            'Show ${_allProjects.length - 3} more projects',
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 5.508 * scale,
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
        SizedBox(height: 3.148 * scale),
        Row(
          children: [
            Icon(
              Icons.info_outline,
              size: 4.721 * scale,
              color: textLightGray,
            ),
            SizedBox(width: 2.361 * scale),
            Text(
              'Select one or more projects for this client',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 4.721 * scale,
                fontWeight: FontWeight.w400,
                color: textLightGray,
                height: 1.33,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInviteCodeField(double scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/icons/invite_icon.png',
              width: 6.295 * scale,
              height: 6.295 * scale,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.lock,
                  size: 6.295 * scale,
                  color: textDark,
                );
              },
            ),
            SizedBox(width: 3.148 * scale),
            Text(
              'Invite Code *',
              style: TextStyle(
                fontFamily: 'Arimo',
                fontSize: 5.508 * scale,
                fontWeight: FontWeight.w400,
                color: textDark,
                height: 1.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.148 * scale),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 18.885 * scale,
                padding: EdgeInsets.symmetric(
                  horizontal: 4.721 * scale,
                  vertical: 0,
                ),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: inputBg,
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.393 * scale,
                  ),
                  borderRadius: BorderRadius.circular(5.508 * scale),
                ),
                child: TextField(
                  controller: _inviteCodeController,
                  readOnly: true,
                  style: TextStyle(
                    fontFamily: 'Cousine',
                    fontSize: 6.295 * scale,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF717182),
                    height: 1.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Click generate to create code',
                    hintStyle: TextStyle(
                      fontFamily: 'Cousine',
                      fontSize: 6.295 * scale,
                      color: const Color(0xFF717182),
                      height: 1.0,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 1.574 * scale,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.148 * scale),
            GestureDetector(
              onTap: _generateCode,
              child: Container(
                width: 18.885 * scale,
                height: 18.885 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: primaryBlue,
                    width: 0.787 * scale,
                  ),
                  borderRadius: BorderRadius.circular(5.508 * scale),
                  boxShadow: [
                    BoxShadow(
                      color: primaryBlue.withOpacity(0.15),
                      offset: Offset(0, 1.574 * scale),
                      blurRadius: 3.148 * scale,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.refresh,
                  size: 6.295 * scale,
                  color: primaryBlue,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 3.148 * scale),
        Text(
          'Share this code with the client for login',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: 4.721 * scale,
            fontWeight: FontWeight.w400,
            color: textLightGray,
            height: 1.33,
          ),
        ),
      ],
    );
  }

  void _showSuccessAnimation(double scale) {
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
                    'Member Added!',
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
                    'The new member has been\nsuccessfully added to your team',
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
                        Navigator.of(context).pop(); // Close dialog
                        // Navigate to WelcomeDashboard
                        Navigator.of(context).pushAndRemoveUntil(
                          _NoAnimationPageRoute(
                            builder: (context) => const WelcomeDashboard(),
                          ),
                          (route) => false,
                        );
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

  Widget _buildAddMemberButton(double scale) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Save member to database
          // Show success animation
          _showSuccessAnimation(scale);
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
              BoxShadow(
                color: primaryBlue.withOpacity(0.3),
                offset: Offset(0, 1.574 * scale),
                blurRadius: 2.361 * scale,
                spreadRadius: -1.574 * scale,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add,
                size: 6.295 * scale,
                color: Colors.white,
              ),
              SizedBox(width: 3.148 * scale),
              Text(
                'Add Member',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.508 * scale,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.43,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

