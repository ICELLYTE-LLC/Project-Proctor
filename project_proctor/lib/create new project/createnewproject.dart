import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../Projects/projects.dart';
import 'projectdetailsfill.dart';

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

class CreateNewProject extends StatefulWidget {
  const CreateNewProject({super.key});

  @override
  State<CreateNewProject> createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 165.0; // Based on Figma design width

    // Colors from Figma
    const bgGray50 = Color(0xFFF9FAFB);
    const bgGray100 = Color(0xFFF3F4F6);
    const textGray900 = Color(0xFF101828);
    const textGray600 = Color(0xFF6A7282);
    const textGray500 = Color(0xFF4A5565);
    const borderGray200 = Color(0xFFD1D5DC);
    const borderGray300 = Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, // Projects is selected
        onTap: (index) {
          if (index == 0) {
            // Already on Projects page - navigate back
            Navigator.of(context).pop();
          } else if (index == 1) {
            // Role button
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const ProjectsPage(),
              ),
              (route) => false,
            );
          } else if (index == 2) {
            // Dashboard button
            Navigator.of(context).pushAndRemoveUntil(
              _NoAnimationPageRoute(
                builder: (context) => const ProjectsPage(),
              ),
              (route) => false,
            );
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
              colors: [
                const Color(0xFFF8FAFC),
                Colors.white,
                const Color(0xFFEFF6FF),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Header
              _buildHeader(scale, textGray900, textGray600, borderGray300),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 9.318 * scale),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15 * scale),
                      // Start with Template Section
                      _buildTemplateSection(scale, textGray900, textGray600, textGray500, bgGray100, borderGray200, borderGray300),
                      SizedBox(height: 9.318 * scale),
                      // Templates List
                      _buildTemplatesList(scale, textGray900, textGray600, textGray500, bgGray100),
                      SizedBox(height: 9.318 * scale),
                      // Start from Scratch
                      _buildStartFromScratch(scale, textGray900, textGray600, bgGray50, borderGray200),
                      SizedBox(height: 20 * scale),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double scale, Color textGray900, Color textGray600, Color borderGray300) {
    return Container(
      height: 29.894 * scale,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(
          bottom: BorderSide(
            color: borderGray300.withOpacity(0.5),
            width: 0.388 * scale,
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 6.212 * scale),
      child: Row(
        children: [
          // Back Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: Container(
                width: 15.529 * scale,
                height: 15.529 * scale,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: borderGray300,
                    width: 0.388 * scale,
                  ),
                  borderRadius: BorderRadius.circular(5.435 * scale),
                ),
                child: Icon(
                  Icons.arrow_back,
                  size: 7.765 * scale,
                  color: textGray900,
                ),
              ),
            ),
          ),
          SizedBox(width: 6.212 * scale),
          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Create New Project',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 6.212 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray900,
                  ),
                ),
                Text(
                  'Choose a template or start from scratch',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: 5.435 * scale,
                    fontWeight: FontWeight.w400,
                    color: textGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSection(double scale, Color textGray900, Color textGray600, Color textGray500, Color bgGray100, Color borderGray200, Color borderGray300) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 7.765 * scale,
                    color: textGray900,
                  ),
                  SizedBox(width: 3.106 * scale),
                  Text(
                    'Start with a Template',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: 6.212 * scale,
                      fontWeight: FontWeight.w400,
                      color: textGray900,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.553 * scale),
              Text(
                'Choose a template to get started faster, or skip to create from scratch',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray600,
                ),
              ),
            ],
          ),
        ),
        // Skip Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                _NoAnimationPageRoute(
                  builder: (context) => const ProjectDetailsFill(),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(4 * scale),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTemplatesList(double scale, Color textGray900, Color textGray600, Color textGray500, Color bgGray100) {
    final templates = [
      {
        'title': 'Commercial Building',
        'description': 'Office buildings, retail spaces, multi-story construction',
        'badges': ['Foundation', 'Framing', 'MEP', 'Finishing'],
        'tasks': '45 tasks',
        'duration': '⏱️ 18-24 months',
        'gradient': [Color(0xFF2B7FFF), Color(0xFF0092B8)],
        'icon': Icons.business,
        'templateTasks': ['Foundation', 'Framing', 'MEP', 'Finishing', 'Site Preparation', 'Excavation', 'Concrete Work', 'Steel Erection', 'Electrical Installation', 'Plumbing Installation', 'HVAC Installation', 'Roofing', 'Windows & Doors', 'Interior Finishing', 'Exterior Finishing'],
      },
      {
        'title': 'Residential Home',
        'description': 'Single-family homes, townhouses, custom builds',
        'badges': ['Site Prep', 'Foundation', 'Framing', 'Interior'],
        'tasks': '32 tasks',
        'duration': '⏱️ 8-12 months',
        'gradient': [Color(0xFFAD46FF), Color(0xFFE60076)],
        'icon': Icons.home,
        'templateTasks': ['Site Preparation', 'Foundation', 'Framing', 'Roofing', 'Windows & Doors', 'Electrical Rough-in', 'Plumbing Rough-in', 'HVAC Installation', 'Insulation', 'Drywall', 'Interior Finishing', 'Exterior Finishing', 'Landscaping'],
      },
      {
        'title': 'Renovation Project',
        'description': 'Interior remodeling, upgrades, restoration work',
        'badges': ['Demolition', 'Electrical', 'Plumbing', 'Finishing'],
        'tasks': '24 tasks',
        'duration': '⏱️ 3-6 months',
        'gradient': [Color(0xFFFF6900), Color(0xFFE7000B)],
        'icon': Icons.build,
        'templateTasks': ['Demolition', 'Electrical Work', 'Plumbing Work', 'HVAC Updates', 'Drywall & Plaster', 'Flooring', 'Painting', 'Cabinetry', 'Fixtures Installation', 'Final Inspection'],
      },
      {
        'title': 'Landscape & Exterior',
        'description': 'Outdoor spaces, hardscaping, landscaping projects',
        'badges': ['Site Work', 'Grading', 'Planting', 'Hardscape'],
        'tasks': '18 tasks',
        'duration': '⏱️ 2-4 months',
        'gradient': [Color(0xFF00C950), Color(0xFF009966)],
        'icon': Icons.park,
        'templateTasks': ['Site Work', 'Grading', 'Drainage', 'Hardscape Installation', 'Planting', 'Irrigation', 'Lighting', 'Final Cleanup'],
      },
      {
        'title': 'Industrial Facility',
        'description': 'Warehouses, manufacturing plants, storage facilities',
        'badges': ['Steel Structure', 'Concrete', 'MEP', 'Equipment'],
        'tasks': '38 tasks',
        'duration': '⏱️ 12-18 months',
        'gradient': [Color(0xFF4A5565), Color(0xFF314158)],
        'icon': Icons.warehouse,
        'templateTasks': ['Site Preparation', 'Steel Structure', 'Concrete Work', 'Roofing', 'MEP Systems', 'Equipment Installation', 'Fire Safety Systems', 'Security Systems', 'Final Inspection'],
      },
      {
        'title': 'Infrastructure Project',
        'description': 'Roads, bridges, utilities, public works',
        'badges': ['Earthwork', 'Concrete', 'Utilities', 'Paving'],
        'tasks': '52 tasks',
        'duration': '⏱️ 24+ months',
        'gradient': [Color(0xFFF0B100), Color(0xFFF54900)],
        'icon': Icons.route,
        'templateTasks': ['Earthwork', 'Grading', 'Drainage', 'Concrete Work', 'Utilities Installation', 'Paving', 'Signage', 'Lighting', 'Final Inspection'],
      },
    ];

    return Column(
      children: templates.map((template) {
        return Padding(
          padding: EdgeInsets.only(bottom: 6.212 * scale),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  _NoAnimationPageRoute(
                    builder: (context) => ProjectDetailsFill(
                      templateName: template['title'] as String,
                      templateTasks: template['templateTasks'] as List<String>,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(5.435 * scale),
              child: _buildTemplateCard(
                scale,
                template['title'] as String,
                template['description'] as String,
                template['badges'] as List<String>,
                template['tasks'] as String,
                template['duration'] as String,
                template['gradient'] as List<Color>,
                template['icon'] as IconData,
                textGray900,
                textGray600,
                textGray500,
                bgGray100,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTemplateCard(
    double scale,
    String title,
    String description,
    List<String> badges,
    String tasks,
    String duration,
    List<Color> gradient,
    IconData icon,
    Color textGray900,
    Color textGray600,
    Color textGray500,
    Color bgGray100,
  ) {
    return Container(
      height: 76.118 * scale,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.435 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3.882 * scale,
            offset: Offset(0, 1.553 * scale),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left gradient border
          Positioned(
            left: 0.78 * scale,
            top: 0.78 * scale,
            child: Container(
              width: 1.553 * scale,
              height: 74.541 * scale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.435 * scale),
                  bottomLeft: Radius.circular(5.435 * scale),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.only(
              left: 10.09 * scale,
              top: 6.99 * scale,
              right: 10.09 * scale,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: 21.741 * scale,
                  height: 21.741 * scale,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.435 * scale),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3.882 * scale,
                        offset: Offset(0, 1.553 * scale),
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: gradient,
                      ),
                      borderRadius: BorderRadius.circular(5.435 * scale),
                    ),
                    child: Icon(
                      icon,
                      size: 10.871 * scale,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 6.212 * scale),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 6.212 * scale,
                          fontWeight: FontWeight.w400,
                          color: textGray900,
                        ),
                      ),
                      SizedBox(height: 1.553 * scale),
                      // Description
                      Text(
                        description,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 5.435 * scale,
                          fontWeight: FontWeight.w400,
                          color: textGray600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.106 * scale),
                      // Badges
                      Wrap(
                        spacing: 3.106 * scale,
                        runSpacing: 3.106 * scale,
                        children: badges.take(4).map((badge) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.494 * scale,
                              vertical: 1.164 * scale,
                            ),
                            decoration: BoxDecoration(
                              color: bgGray100,
                              borderRadius: BorderRadius.circular(3.106 * scale),
                            ),
                            child: Text(
                              badge,
                              style: TextStyle(
                                fontFamily: 'Arimo',
                                fontSize: 4.659 * scale,
                                fontWeight: FontWeight.w400,
                                color: textGray500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 3.106 * scale),
                      // Tasks and Duration
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.checklist,
                                size: 4.659 * scale,
                                color: textGray600,
                              ),
                              SizedBox(width: 1.553 * scale),
                              Text(
                                tasks,
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: 4.659 * scale,
                                  fontWeight: FontWeight.w400,
                                  color: textGray600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 6.212 * scale),
                          Text(
                            duration,
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: 4.659 * scale,
                              fontWeight: FontWeight.w400,
                              color: textGray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6.212 * scale),
                // Arrow Icon
                Container(
                  width: 12.424 * scale,
                  height: 12.424 * scale,
                  decoration: BoxDecoration(
                    color: bgGray100,
                    borderRadius: BorderRadius.circular(3.882 * scale),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 6.212 * scale,
                    color: textGray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartFromScratch(double scale, Color textGray900, Color textGray600, Color bgGray50, Color borderGray200) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            _NoAnimationPageRoute(
              builder: (context) => const ProjectDetailsFill(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(5.435 * scale),
        child: Container(
          height: 69.882 * scale,
          decoration: BoxDecoration(
            color: bgGray50,
            border: Border.all(
              color: borderGray200,
              width: 0.776 * scale,
            ),
            borderRadius: BorderRadius.circular(5.435 * scale),
          ),
          padding: EdgeInsets.all(10.094 * scale),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 18.635 * scale,
                height: 18.635 * scale,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5.435 * scale),
                ),
                child: Center(
                  child: Text(
                    '➕',
                    style: TextStyle(
                      fontSize: 9.318 * scale,
                      color: textGray900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.106 * scale),
              Text(
                'Start from Scratch',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 6.212 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray900,
                ),
              ),
              SizedBox(height: 1.553 * scale),
              Text(
                'Create a custom project with your own specifications',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: 5.435 * scale,
                  fontWeight: FontWeight.w400,
                  color: textGray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

