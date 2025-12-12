import 'package:flutter/material.dart';

class AppBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showRoleInsteadOfDashboard;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showRoleInsteadOfDashboard = false,
  });

  @override
  State<AppBottomNavigation> createState() => _AppBottomNavigationState();
}

class _AppBottomNavigationState extends State<AppBottomNavigation>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      5,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      ),
    );
    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(begin: 1.0, end: 0.9).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTapDown(int index) {
    _animationControllers[index].forward();
  }

  void _onTapUp(int index) {
    _animationControllers[index].reverse();
    widget.onTap(index);
  }

  void _onTapCancel(int index) {
    _animationControllers[index].reverse();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive values based on screen width
    final navHeight = screenHeight * 0.10;
    final horizontalPadding = screenWidth * 0.06;
    final iconSize = screenWidth * 0.065;
    final labelFontSize = screenWidth * 0.035; // Increased font size
    final dashboardSize = screenWidth * 0.17;
    final dashboardIconSize = screenWidth * 0.062;
    final dashboardOffset = screenHeight * -0.014;

    // Determine which icon is selected and build navigation items accordingly
    final selectedIndex = widget.currentIndex;
    
    // Define all navigation items
    final navItems = [
      {
        'index': 0,
        'assetPath': 'assets/icons/projects_icon.png',
        'label': 'Projects',
      },
      {
        'index': 1,
        'assetPath': widget.showRoleInsteadOfDashboard 
            ? 'assets/icons/dashboard_icon.png' 
            : 'assets/icons/role_icon.png',
        'label': widget.showRoleInsteadOfDashboard ? 'Dashboard' : 'Role',
      },
      {
        'index': 2,
        'assetPath': widget.showRoleInsteadOfDashboard 
            ? 'assets/icons/role_icon.png' 
            : 'assets/icons/dashboard_icon.png',
        'label': widget.showRoleInsteadOfDashboard ? 'Role' : 'Dashboard',
      },
      {
        'index': 3,
        'assetPath': 'assets/icons/setting_icon.png',
        'label': 'Settings',
      },
      {
        'index': 4,
        'assetPath': 'assets/icons/logout_icon.png',
        'label': 'Logout',
      },
    ];

    // Build all navigation items, with selected item in center position (position 2)
    final allNavWidgets = <Widget>[];
    
    // Get all items except selected
    final otherItems = navItems.where((item) => item['index'] as int != selectedIndex).toList();
    
    // We need 2 items on left, selected in center, 2 items on right
    // Take first 2 from otherItems for left side
    for (int i = 0; i < 2 && i < otherItems.length; i++) {
      final item = otherItems[i];
      allNavWidgets.add(
        Expanded(
          flex: 1,
          child: _buildNavItemOnSide(
            index: item['index'] as int,
            assetPath: item['assetPath'] as String,
            label: item['label'] as String,
            iconSize: iconSize.clamp(22, 28),
            labelFontSize: labelFontSize.clamp(9, 12),
          ),
        ),
      );
    }
    
    // Add selected item in center
    allNavWidgets.add(
      Expanded(
        flex: 1,
        child: _buildNavItemInCenter(
          index: selectedIndex,
          assetPath: navItems[selectedIndex]['assetPath'] as String,
          label: navItems[selectedIndex]['label'] as String,
          dashboardSize: dashboardSize,
          dashboardIconSize: dashboardIconSize,
          dashboardOffset: dashboardOffset,
          labelFontSize: labelFontSize,
        ),
      ),
    );
    
    // Take remaining items for right side
    for (int i = 2; i < otherItems.length; i++) {
      final item = otherItems[i];
      allNavWidgets.add(
        Expanded(
          flex: 1,
          child: _buildNavItemOnSide(
            index: item['index'] as int,
            assetPath: item['assetPath'] as String,
            label: item['label'] as String,
            iconSize: iconSize.clamp(22, 28),
            labelFontSize: labelFontSize.clamp(9, 12),
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Container(
        key: const ValueKey('nav_bar_container'), // Stable key for container
        height: navHeight.clamp(85, 105), // Further increased height to prevent overflow
        clipBehavior: Clip.none,
        padding: EdgeInsets.only(bottom: 12), // Increased bottom padding
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x731D63D8), // Pre-calculated alpha value
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding.clamp(20, 30)),
          child: Row(
            key: ValueKey('nav_row_$selectedIndex'), // Key changes only when selection changes
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Even spacing
            crossAxisAlignment: CrossAxisAlignment.center,
            children: allNavWidgets,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItemOnSide({
    required int index,
    required String assetPath,
    required String label,
    required double iconSize,
    required double labelFontSize,
  }) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(index),
        onTapUp: (_) => _onTapUp(index),
        onTapCancel: () => _onTapCancel(index),
        child: AnimatedBuilder(
          animation: _scaleAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -4), // Raise to align with other icons
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Image.asset(
                        assetPath,
                        width: iconSize,
                        height: iconSize,
                        color: const Color(0xFF6A7282),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Transform.translate(
                    offset: const Offset(0, -2), // Text moved up for unselected
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Arimo',
                        fontSize: labelFontSize.clamp(11, 14),
                        color: const Color(0xFF6A7282),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItemInCenter({
    required int index,
    required String assetPath,
    required String label,
    required double dashboardSize,
    required double dashboardIconSize,
    required double dashboardOffset,
    required double labelFontSize,
  }) {
    return Center(
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(index),
        onTapUp: (_) => _onTapUp(index),
        onTapCancel: () => _onTapCancel(index),
        child: AnimatedBuilder(
          animation: _scaleAnimations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              alignment: Alignment.center,
              child: Transform.translate(
                offset: Offset(0, dashboardOffset.clamp(-25, -10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: dashboardSize.clamp(50, 63),
                      height: dashboardSize.clamp(50, 63),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF2779F5),
                            Color(0xFF1D63D8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1D63D8).withValues(alpha: 0.45),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          assetPath,
                          width: dashboardIconSize.clamp(20, 26),
                          height: dashboardIconSize.clamp(20, 26),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    Transform.translate(
                      offset: const Offset(0, 2),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Arimo',
                          fontSize: (labelFontSize * 0.9).clamp(10, 12),
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}
