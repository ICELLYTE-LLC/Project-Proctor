import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_navigation.dart';

class projects extends StatefulWidget {
  const projects({super.key});

  @override
  State<projects> createState() => _projectsState();
}

class _projectsState extends State<projects> {
  final TextEditingController _searchController = TextEditingController();
  
  // Color constants for success popup
  static const Color primaryBlue = Color(0xFF2779F5);
  static const Color primaryBlueDark = Color(0xFF1447E6);
  static const Color textDark = Color(0xFF101828);
  static const Color textGray = Color(0xFF6A7282);

  // Sample data for subcontractors
  final List<Map<String, dynamic>> subcontractors = [
    {
      'name': 'Mike Chen',
      'company': 'Elite Electrical',
      'trade': 'Electrical',
      'tradeColor': const Color(0xFF2196F3),
      'status': 'active',
      'statusColor': const Color(0xFF4CAF50),
      'phone': '(555) 123-4567',
      'email': 'mike@eliteelectrical.com',
    },
    {
      'name': 'Sarah Williams',
      'company': 'Pro Plumbing Co',
      'trade': 'Plumbing',
      'tradeColor': const Color(0xFF2196F3),
      'status': 'active',
      'statusColor': const Color(0xFF4CAF50),
      'phone': '(555) 234-5678',
      'email': 'sarah@proplumbing.com',
    },
    {
      'name': 'David Rodriguez',
      'company': 'Summit HVAC',
      'trade': 'HVAC',
      'tradeColor': const Color(0xFF9C27B0),
      'status': null,
      'statusColor': null,
      'phone': '(555) 345-6789',
      'email': 'david@summithvac.com',
    },
    {
      'name': 'Emily Taylor',
      'company': 'Precision Concrete',
      'trade': 'Concrete',
      'tradeColor': const Color(0xFF607D8B),
      'status': 'completed',
      'statusColor': const Color(0xFF607D8B),
      'phone': '(555) 456-7890',
      'email': 'emily@precisionconcrete.com',
    },
    {
      'name': 'James Anderson',
      'company': 'Anderson Steel Works',
      'trade': 'Steel',
      'tradeColor': const Color(0xFF607D8B),
      'status': 'completed',
      'statusColor': const Color(0xFF607D8B),
      'phone': '(555) 567-8901',
      'email': 'james@andersonsteel.com',
    },
    {
      'name': 'Lisa Martinez',
      'company': 'Perfect Finishes',
      'trade': 'Finishes',
      'tradeColor': const Color(0xFFFF9800),
      'status': 'consultant',
      'statusColor': const Color(0xFFFF9800),
      'phone': '(555) 678-9012',
      'email': 'lisa@perfectfinishes.com',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(screenWidth, screenHeight),
            // Search Bar
            _buildSearchBar(screenWidth, screenHeight),
            // Add Subcontractor Button
            _buildAddButton(screenWidth, screenHeight),
            // Subcontractors List
            Expanded(child: _buildSubcontractorsList(screenWidth, screenHeight)),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0, // Projects selected
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight) {
    final padding = screenWidth * 0.04;
    final arrowSize = screenWidth * 0.06;
    final titleFontSize = screenWidth * 0.06;
    final subtitleFontSize = screenWidth * 0.035;

    return Padding(
      padding: EdgeInsets.all(padding.clamp(12.0, 20.0)),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/icons/arrow_icon.png',
              width: arrowSize.clamp(20.0, 28.0),
              height: arrowSize.clamp(20.0, 28.0),
              color: Colors.black,
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subcontractors',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: titleFontSize.clamp(20.0, 28.0),
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              Text(
                '${subcontractors.length} team members',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: subtitleFontSize.clamp(12.0, 16.0),
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth, double screenHeight) {
    final horizontalPadding = screenWidth * 0.04;
    final borderRadius = screenWidth * 0.03;
    final iconSize = screenWidth * 0.05;
    final fontSize = screenWidth * 0.035;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.clamp(12.0, 20.0)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(borderRadius.clamp(10.0, 16.0)),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            fontFamily: 'Arimo',
            fontSize: fontSize.clamp(12.0, 16.0),
          ),
          decoration: InputDecoration(
            hintText: 'Search contractors...',
            hintStyle: TextStyle(
              fontFamily: 'Arimo',
              color: const Color(0xFF6B7280),
              fontSize: fontSize.clamp(12.0, 16.0),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Image.asset(
                'assets/icons/search_icon.png',
                width: iconSize.clamp(18.0, 24.0),
                height: iconSize.clamp(18.0, 24.0),
                color: Colors.grey,
              ),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.018,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(double screenWidth, double screenHeight) {
    final padding = screenWidth * 0.04;
    final borderRadius = screenWidth * 0.03;
    final iconSize = screenWidth * 0.05;
    final fontSize = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.012;

    return Padding(
      padding: EdgeInsets.all(padding.clamp(12.0, 20.0)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF155DFC), Color(0xFF1447E6)],
          ),
          borderRadius: BorderRadius.circular(borderRadius.clamp(10.0, 16.0)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1447E6).withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            // Add subcontractor action
          },
          icon: Icon(Icons.add, color: Colors.white, size: iconSize.clamp(18.0, 24.0)),
          label: Text(
            'Add Subcontractor',
            style: TextStyle(
              fontFamily: 'Arimo',
              color: Colors.white,
              fontSize: fontSize.clamp(14.0, 18.0),
              fontWeight: FontWeight.w500,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: verticalPadding.clamp(8.0, 14.0)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.clamp(10.0, 16.0)),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildSubcontractorsList(double screenWidth, double screenHeight) {
    final horizontalPadding = screenWidth * 0.04;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding.clamp(12.0, 20.0)),
      itemCount: subcontractors.length,
      itemBuilder: (context, index) {
        return _buildSubcontractorCard(subcontractors[index], screenWidth, screenHeight);
      },
    );
  }

  Widget _buildSubcontractorCard(Map<String, dynamic> subcontractor, double screenWidth, double screenHeight) {
    // Get initials from name
    final nameParts = subcontractor['name'].split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'
        : nameParts[0][0];

    // Responsive values
    final cardPadding = screenWidth * 0.05;
    final cardBorderRadius = screenWidth * 0.04;
    final cardMargin = screenWidth * 0.04;
    final avatarSize = screenWidth * 0.13;
    final accentSize = screenWidth * 0.15;
    final nameFontSize = screenWidth * 0.04;
    final companyFontSize = screenWidth * 0.033;
    final contactFontSize = screenWidth * 0.035;
    final initialsFontSize = screenWidth * 0.04;
    final contactIconSize = screenWidth * 0.04;
    final actionIconSize = screenWidth * 0.05;
    final tagFontSize = screenWidth * 0.028;
    final tagIconSize = screenWidth * 0.03;
    final contactIconPadding = screenWidth * 0.02;
    final contactIconBorderRadius = screenWidth * 0.02;

    return Container(
      margin: EdgeInsets.only(bottom: cardMargin.clamp(12.0, 20.0)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cardBorderRadius.clamp(12.0, 20.0)),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Top right corner accent
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: accentSize.clamp(50.0, 70.0),
              height: accentSize.clamp(50.0, 70.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF00B8DB).withValues(alpha: 0.05),
                    const Color(0xFF2B7FFF).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(cardBorderRadius.clamp(12.0, 20.0)),
                  bottomLeft: Radius.circular(accentSize.clamp(50.0, 70.0)),
                ),
              ),
            ),
          ),
          // Main content
          Padding(
            padding: EdgeInsets.all(cardPadding.clamp(16.0, 24.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row with avatar, name, company, tags, and action buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with initials
                    Container(
                      width: avatarSize.clamp(44.0, 60.0),
                      height: avatarSize.clamp(44.0, 60.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF4),
                        borderRadius: BorderRadius.circular(avatarSize.clamp(44.0, 60.0) / 2),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: initialsFontSize.clamp(14.0, 18.0),
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.035),
                    // Name, company, and tags
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subcontractor['name'],
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: nameFontSize.clamp(14.0, 18.0),
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            subcontractor['company'],
                            style: TextStyle(
                              fontFamily: 'Arimo',
                              fontSize: companyFontSize.clamp(11.0, 15.0),
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.012),
                          // Trade and Status tags
                          Row(
                            children: [
                              _buildTagWithIcon(
                                subcontractor['trade'],
                                subcontractor['tradeColor'],
                                tagFontSize,
                                tagIconSize,
                              ),
                              if (subcontractor['status'] != null) ...[
                                SizedBox(width: screenWidth * 0.02),
                                _buildTag(
                                  subcontractor['status'],
                                  subcontractor['statusColor'],
                                  tagFontSize,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Edit and Delete buttons in a row
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // Edit action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Edit ${subcontractor['name']}')),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.01),
                            child: Image.asset(
                              'assets/icons/edit_icon.png',
                              width: actionIconSize.clamp(18.0, 24.0),
                              height: actionIconSize.clamp(18.0, 24.0),
                              color: const Color(0xFF2196F3),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        InkWell(
                          onTap: () {
                            // Delete action
                            _showDeleteDialog(subcontractor);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.01),
                            child: Image.asset(
                              'assets/icons/delete_icon.png',
                              width: actionIconSize.clamp(18.0, 24.0),
                              height: actionIconSize.clamp(18.0, 24.0),
                              color: const Color(0xFFEF5350),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                // Divider
                Container(height: 1, color: const Color(0xFFE8E8E8)),
                SizedBox(height: screenHeight * 0.02),
                // Phone
                InkWell(
                  onTap: () => _makePhoneCall(subcontractor['phone']),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(contactIconPadding.clamp(6.0, 10.0)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F1F3),
                          borderRadius: BorderRadius.circular(contactIconBorderRadius.clamp(6.0, 10.0)),
                        ),
                        child: Image.asset(
                          'assets/icons/phone_icon.png',
                          width: contactIconSize.clamp(14.0, 18.0),
                          height: contactIconSize.clamp(14.0, 18.0),
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.025),
                      Text(
                        subcontractor['phone'],
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: contactFontSize.clamp(12.0, 16.0),
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.012),
                // Email
                InkWell(
                  onTap: () => _sendEmail(subcontractor['email']),
                  borderRadius: BorderRadius.circular(8),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(contactIconPadding.clamp(6.0, 10.0)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F1F3),
                          borderRadius: BorderRadius.circular(contactIconBorderRadius.clamp(6.0, 10.0)),
                        ),
                        child: Image.asset(
                          'assets/icons/email_icon.png',
                          width: contactIconSize.clamp(14.0, 18.0),
                          height: contactIconSize.clamp(14.0, 18.0),
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.025),
                      Text(
                        subcontractor['email'],
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: contactFontSize.clamp(12.0, 16.0),
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagWithIcon(String text, Color color, double fontSize, double iconSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize.clamp(9.0, 13.0) * 0.7,
        vertical: fontSize.clamp(9.0, 13.0) * 0.35,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/job_icon.png',
            width: iconSize.clamp(10.0, 14.0),
            height: iconSize.clamp(10.0, 14.0),
            color: color,
          ),
          SizedBox(width: fontSize.clamp(9.0, 13.0) * 0.35),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: fontSize.clamp(9.0, 13.0),
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color, double fontSize) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize.clamp(9.0, 13.0) * 0.7,
        vertical: fontSize.clamp(9.0, 13.0) * 0.35,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Arimo',
          fontSize: fontSize.clamp(9.0, 13.0),
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // Helper methods for phone and email
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _showDeleteDialog(Map<String, dynamic> subcontractor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subcontractor'),
          content: Text('Are you sure you want to delete ${subcontractor['name']}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${subcontractor['name']} deleted')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
<<<<<<< Updated upstream:project_proctor/lib/subcontractor/projects.dart
          ],
=======
          ),
        );
      },
    );
  }

  void _showAddSubcontractorDialog() {
    final nameController = TextEditingController();
    final companyController = TextEditingController();
    final tradeController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = (screenWidth * 0.85).clamp(280.0, 320.0);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFFFFFFFF),
          child: Container(
            width: dialogWidth,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and close button
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Center(
                        child: Text(
                          'Add Subcontractor',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Name field
                _buildDialogTextField('Name', 'Name', nameController),
                const SizedBox(height: 10),
                // Company field
                _buildDialogTextField('Company', 'Company', companyController),
                const SizedBox(height: 10),
                // Trade field
                _buildDialogTextField('Trade', 'Trade', tradeController),
                const SizedBox(height: 10),
                // Phone field
                _buildDialogTextField('Phone', 'Phone', phoneController),
                const SizedBox(height: 10),
                // Email field
                _buildDialogTextField('Email', 'Email', emailController),
                const SizedBox(height: 16),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Add subcontractor logic here
                          Navigator.of(context).pop(); // Close add dialog
                          // Show success animation
                          final scale = MediaQuery.of(context).size.width / 165.0;
                          _showSuccessAnimation(context, scale, isEdit: false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF155DFC),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
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

  Widget _buildDialogTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Arimo',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Arimo',
            fontSize: 12,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Arimo',
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  void _showEditSubcontractorDialog(Map<String, dynamic> subcontractor) {
    final nameController = TextEditingController(text: subcontractor['name']);
    final companyController = TextEditingController(text: subcontractor['company']);
    final tradeController = TextEditingController(text: subcontractor['trade']);
    final phoneController = TextEditingController(text: subcontractor['phone']);
    final emailController = TextEditingController(text: subcontractor['email']);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = (screenWidth * 0.85).clamp(280.0, 320.0);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFFFFFFFF),
          child: Container(
            width: dialogWidth,
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and close button
                Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Center(
                        child: Text(
                          'Edit Subcontractor',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Name field
                _buildDialogTextField('Name', 'Mike Chen', nameController),
                const SizedBox(height: 10),
                // Company field
                _buildDialogTextField('Company', 'Elite Electrical', companyController),
                const SizedBox(height: 10),
                // Trade field
                _buildDialogTextField('Trade', 'Electrical', tradeController),
                const SizedBox(height: 10),
                // Phone field
                _buildDialogTextField('Phone', '(555) 123-4567', phoneController),
                const SizedBox(height: 10),
                // Email field
                _buildDialogTextField('Email', 'mike@eliteelectrical.com', emailController),
                const SizedBox(height: 16),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          side: const BorderSide(color: Color(0xFFD1D5DB), width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Update subcontractor logic here
                          Navigator.of(context).pop(); // Close edit dialog
                          // Show success animation
                          final scale = MediaQuery.of(context).size.width / 165.0;
                          _showSuccessAnimation(context, scale, isEdit: true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF155DFC),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Text(
                          'Update',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
>>>>>>> Stashed changes:project_proctor/lib/admin/subcontractor.dart
        );
      },
    );
  }

  void _showSuccessAnimation(BuildContext context, double scale, {required bool isEdit}) {
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
                    isEdit ? 'Member Updated!' : 'Member Added!',
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
                    isEdit
                        ? 'The team member has been\nsuccessfully updated'
                        : 'The new team member has been\nsuccessfully added to your team',
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
}
