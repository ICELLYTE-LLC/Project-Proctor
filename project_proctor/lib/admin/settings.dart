import 'package:flutter/material.dart';
import '../widgets/bottom_navigation.dart';
import '../Welcome Dashboard/welcomedashboard.dart';
import '../Projects/projects.dart';
import '../Add New Member/addnewmember.dart';
import 'logout_dialog.dart';

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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  String _selectedLanguage = 'English';

  final List<Map<String, String>> _languages = [
    {'name': 'English', 'flag': '🇺🇸'},
    {'name': 'Spanish', 'flag': '🇪🇸'},
    {'name': 'French', 'flag': '🇫🇷'},
    {'name': 'German', 'flag': '🇩🇪'},
    {'name': 'Italian', 'flag': '🇮🇹'},
    {'name': 'Portuguese', 'flag': '🇵🇹'},
    {'name': 'Chinese', 'flag': '🇨🇳'},
    {'name': 'Japanese', 'flag': '🇯🇵'},
    {'name': 'Korean', 'flag': '🇰🇷'},
    {'name': 'Arabic', 'flag': '🇸🇦'},
    {'name': 'Russian', 'flag': '🇷🇺'},
    {'name': 'Hindi', 'flag': '🇮🇳'},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
        backgroundColor: const Color(0xFFFFFFFF),
        extendBody: true,
        bottomNavigationBar: AppBottomNavigation(
        currentIndex: 3, // Settings is selected
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
            // Dashboard button - navigate back if we came from a dashboard page
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
          } else if (index == 3) {
            // Already on Settings page - do nothing
            return;
          } else if (index == 4) {
            // Logout
            LogoutDialog.show(context);
          }
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                color: const Color(0xFFFFFFFF),
                padding: EdgeInsets.only(
                  left: screenWidth > 500 ? 24 : 16,
                  right: screenWidth > 500 ? 24 : 16,
                  top: screenWidth > 500 ? 16 : 12,
                  bottom: screenWidth > 500 ? 16 : 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: screenWidth > 500 ? 24 : 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your account preferences',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: screenWidth > 500 ? 14 : 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              // Content section with gray background
              Container(
                  width: double.infinity,
                  color: const Color(0xFFF9FAFB),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 500 ? 24 : 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      // Pro Plan Card
                      _buildProPlanCard(screenWidth),
                      const SizedBox(height: 20),

                      // Language & Region Section
                      _buildLanguageRegionSection(screenWidth),
                      const SizedBox(height: 16),

                      // Notifications Section
                      _buildNotificationsSection(screenWidth),
                      const SizedBox(height: 16),

                      // Billing & Payment Section
                      _buildBillingPaymentSection(screenWidth),
                      const SizedBox(height: 16),

                      // Security & Privacy Section
                      _buildSecurityPrivacySection(screenWidth),
                      const SizedBox(height: 16),

                      // Support Section
                      _buildSupportSection(screenWidth),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildProPlanCard(double screenWidth) {
    final isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B7FFF),
            Color(0xFF6B47DD),
            Color(0xFF9810FA),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(isSmallScreen ? 18 : 24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isSmallScreen ? 42 : 48,
                height: isSmallScreen ? 42 : 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 14),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/pro_plan_icon.png',
                    width: isSmallScreen ? 20 : 24,
                    height: isSmallScreen ? 20 : 24,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Pro Plan',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: isSmallScreen ? 6 : 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 6 : 8,
                            vertical: isSmallScreen ? 2 : 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/icons/approved_small_icon.png',
                                width: isSmallScreen ? 10 : 12,
                                height: isSmallScreen ? 10 : 12,
                                color: Colors.white,
                              ),
                              SizedBox(width: isSmallScreen ? 2 : 3),
                              Text(
                                'Active',
                                style: TextStyle(
                                  fontFamily: 'Arimo',
                                  fontSize: isSmallScreen ? 10 : 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$49/month',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 12 : 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 14 : 18,
                  vertical: isSmallScreen ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
                ),
                child: Text(
                  'Upgrade',
                  style: TextStyle(
                    fontFamily: 'Arimo',
                    fontSize: isSmallScreen ? 12 : 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF51A2FF),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 18 : 24),
          Row(
            children: [
              Image.asset(
                'assets/icons/calendar_icon.png',
                width: isSmallScreen ? 14 : 16,
                height: isSmallScreen ? 14 : 16,
                color: Colors.white,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Next billing: November 25, 2025',
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 18 : 24),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          SizedBox(height: isSmallScreen ? 18 : 24),
          Text(
            'Current Features:',
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: isSmallScreen ? 14 : 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isSmallScreen ? 14 : 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItemWhite(Icons.auto_awesome, 'Unlimited Projects'),
                    const SizedBox(height: 14),
                    _buildFeatureItemWhite(Icons.auto_awesome, 'PDF Export'),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItemWhite(Icons.auto_awesome, 'Team Collaboration'),
                    const SizedBox(height: 14),
                    _buildFeatureItemWhite(Icons.auto_awesome, 'Priority Support'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItemWhite(IconData icon, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Row(
      children: [
        Image.asset(
          'assets/icons/current_features_icon.png',
          width: isSmallScreen ? 14 : 16,
          height: isSmallScreen ? 14 : 16,
          color: Colors.white,
        ),
        SizedBox(width: isSmallScreen ? 6 : 8),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: isSmallScreen ? 12 : 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageRegionSection(double screenWidth) {
    final isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF00C950), Color(0xFF009966)],
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/language_&_region_icon.png',
                    width: isSmallScreen ? 18 : 20,
                    height: isSmallScreen ? 18 : 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language & Region',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose your preferred language',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          Text(
            'Language',
            style: TextStyle(
              fontFamily: 'Arimo',
              fontSize: isSmallScreen ? 13 : 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF475569),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xFF6B7280),
              ),
              style: const TextStyle(
                fontFamily: 'Arimo',
                fontSize: 14,
                color: Color(0xFF0F172A),
              ),
              dropdownColor: Colors.white,
              items: _languages.map((language) {
                return DropdownMenuItem<String>(
                  value: language['name'],
                  child: Row(
                    children: [
                      Text(
                        language['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        language['name']!,
                        style: const TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                }
              },
              selectedItemBuilder: (BuildContext context) {
                return _languages.map((language) {
                  return Row(
                    children: [
                      Text(
                        language['flag']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        language['name']!,
                        style: const TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: 14,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(double screenWidth) {
    final isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF6900), Color(0xFFE7000B)],
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/notifications_icon.png',
                    width: isSmallScreen ? 18 : 20,
                    height: isSmallScreen ? 18 : 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage notification preferences',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildToggleRow(
            'Push Notifications',
            'Get notified about updates',
            _pushNotifications,
            (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SizedBox(height: isSmallScreen ? 18 : 20),
          _buildToggleRow(
            'Email Updates',
            'Get email about product updates',
            _emailUpdates,
            (value) {
              setState(() {
                _emailUpdates = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: isSmallScreen ? 13 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: isSmallScreen ? 11 : 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.6,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF0F172A),
            activeThumbColor: Colors.white,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _buildBillingPaymentSection(double screenWidth) {
    final isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2B7FFF), Color(0xFF0092B8)],
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/billing_&_payment_icon.png',
                    width: isSmallScreen ? 18 : 20,
                    height: isSmallScreen ? 18 : 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Billing & Payment',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your subscription',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildSettingsRow('Payment Method', 'Manage your cards'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 18),
            child: const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          _buildSettingsRow('Billing History', 'View past invoices'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 18),
            child: const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          _buildSettingsRow('Change Plan', 'Upgrade or downgrade'),
        ],
      ),
    );
  }

  Widget _buildSecurityPrivacySection(double screenWidth) {
    final isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFAD46FF), Color(0xFFE60076)],
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/security_&_privacy_icon.png',
                    width: isSmallScreen ? 18 : 20,
                    height: isSmallScreen ? 18 : 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security & Privacy',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your account',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          _buildSettingsRow('Change Password', 'Update your password'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16 : 18),
            child: const Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          _buildSettingsRow('Two-Factor Authentication', 'Add extra security'),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(String title, String subtitle) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: isSmallScreen ? 13 : 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Arimo',
                  fontSize: isSmallScreen ? 11 : 12,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: isSmallScreen ? 14 : 16,
          color: const Color(0xFF6B7280),
        ),
      ],
    );
  }

  Widget _buildSupportSection(double screenWidth) {
    final isSmallScreen = screenWidth < 500;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF615FFF), Color(0xFF155DFC)],
                  ),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/support_icon.png',
                    width: isSmallScreen ? 18 : 20,
                    height: isSmallScreen ? 18 : 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Support',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get help when you need it',
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: isSmallScreen ? 12 : 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          Container(
            width: double.infinity,
            height: isSmallScreen ? 44 : 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Handle contact us
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/support_small_icon.png',
                    width: isSmallScreen ? 16 : 18,
                    height: isSmallScreen ? 16 : 18,
                    color: Colors.white,
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 8),
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontFamily: 'Arimo',
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
