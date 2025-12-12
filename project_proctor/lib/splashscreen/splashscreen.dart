import 'package:flutter/material.dart';
import 'package:project_proctor/Welcome Dashboard/welcomedashboard.dart';
import 'dart:async';
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _loadingController;
  late AnimationController _backgroundController;
  
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _loadingAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    
    // Logo animation controller - coming in animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
    
    // Background animation controller
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    
    // Logo animations - coming in from top with scale and fade
    _logoSlideAnimation = Tween<double>(begin: -50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
      ),
    );
    
    // Text animation
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );
    
    // Loading animation
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Background animation
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start animations
    _startAnimations();
    
    // Navigate after delay (total animation time + loading)
    Timer(const Duration(milliseconds: 4000), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeDashboard()),
        );
      }
    });
  }

  void _startAnimations() {
    // Start logo animation immediately
    _logoController.forward();
    
    // Start text animation after logo animation starts
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _loadingController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final baseWidth = 167.0;
    final scale = (screenWidth / baseWidth).clamp(0.8, 2.0);

    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A2947), // Dark blue
                  const Color(0xFF2779F5), // Medium blue
                  const Color(0xFF1D63D8), // Bright blue
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                _buildAnimatedBackground(scale),
                
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with coming in animation
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _logoSlideAnimation.value * scale),
                            child: FadeTransition(
                              opacity: _logoFadeAnimation,
                              child: ScaleTransition(
                                scale: _logoScaleAnimation,
                                child: Container(
                                  width: 50.286 * scale,
                                  height: 50.286 * scale,
                                  padding: EdgeInsets.all(6.286 * scale),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9.429 * scale),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: Offset(0, 9.821 * scale),
                                        blurRadius: 19.643 * scale,
                                        spreadRadius: -4.714 * scale,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/icons/admin_dashboard_logo.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback if image not found
                                      return Icon(
                                        Icons.construction,
                                        size: 30 * scale,
                                        color: const Color(0xFF2779F5),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 12 * scale),
                      
                      // App name with animation
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Text(
                          'Project Proctor',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 6.286 * scale,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 6 * scale),
                      
                      // Tagline with animation
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: Text(
                          'On time. On budget. On screen.',
                          style: TextStyle(
                            fontFamily: 'Arimo',
                            fontSize: 7.071 * scale,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.177 * scale,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20 * scale),
                      
                      // Loading dots with animation
                      FadeTransition(
                        opacity: _textFadeAnimation,
                        child: _buildLoadingDots(scale),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground(double scale) {
    return Stack(
      children: [
        // Large blurred circles
        Positioned(
          left: 4.17 * scale,
          top: -3.02 * scale,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (0.5 - _backgroundAnimation.value) * 10 * scale,
                  (0.5 - _backgroundAnimation.value) * 5 * scale,
                ),
                child: Container(
                  width: 178.489 * scale,
                  height: 178.489 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.143 * scale, sigmaY: 25.143 * scale),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        Positioned(
          left: -3.15 * scale,
          top: 212.65 * scale,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (_backgroundAnimation.value - 0.5) * 8 * scale,
                  (0.5 - _backgroundAnimation.value) * 6 * scale,
                ),
                child: Container(
                  width: 153.397 * scale,
                  height: 153.397 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.143 * scale, sigmaY: 25.143 * scale),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        Positioned(
          left: 26.51 * scale,
          top: 7.26 * scale,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (0.5 - _backgroundAnimation.value) * 6 * scale,
                  (_backgroundAnimation.value - 0.5) * 4 * scale,
                ),
                child: Container(
                  width: 148.911 * scale,
                  height: 148.911 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2779F5).withOpacity(0.1),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.714 * scale, sigmaY: 15.714 * scale),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        Positioned(
          left: -4.75 * scale,
          top: 223.1 * scale,
          child: AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                  (_backgroundAnimation.value - 0.5) * 7 * scale,
                  (0.5 - _backgroundAnimation.value) * 5 * scale,
                ),
                child: Container(
                  width: 141.505 * scale,
                  height: 141.505 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1D63D8).withOpacity(0.1),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.714 * scale, sigmaY: 15.714 * scale),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Small particles
        ...List.generate(6, (index) {
          final positions = [
            {'x': 33.12, 'y': 108.37, 'size': 3.68, 'opacity': 0.252},
            {'x': 57.71, 'y': 176.19, 'size': 4.593, 'opacity': 0.404},
            {'x': 82.71, 'y': 250.59, 'size': 4.681, 'opacity': 0.444},
            {'x': 107.93, 'y': 103.08, 'size': 4.341, 'opacity': 0.335},
            {'x': 133.21, 'y': 182.01, 'size': 3.865, 'opacity': 0.269},
            {'x': 158.44, 'y': 260.14, 'size': 3.487, 'opacity': 0.231},
          ];
          
          final pos = positions[index];
          return Positioned(
            left: pos['x']! * scale,
            top: pos['y']! * scale,
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) {
                final offset = (0.5 - _backgroundAnimation.value) * 2 * scale;
                return Transform.translate(
                  offset: Offset(offset, offset),
                  child: Opacity(
                    opacity: (pos['opacity'] as double) * (0.8 + 0.4 * _backgroundAnimation.value),
                    child: Container(
                      width: pos['size']! * scale,
                      height: pos['size']! * scale,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
        
        // Gradient overlay at bottom
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            height: 50.286 * scale,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingDots(double scale) {
    return AnimatedBuilder(
      animation: _loadingAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final animationValue = ((_loadingAnimation.value + delay) % 1.0);
            final opacity = (animationValue < 0.5)
                ? 0.5 + (animationValue * 0.5)
                : 1.0 - ((animationValue - 0.5) * 0.5);
            final size = 3.143 * scale + (animationValue < 0.5 ? animationValue * 1.5 * scale : (1.0 - animationValue) * 1.5 * scale);
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 1.1 * scale),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8 * opacity),
              ),
            );
          }),
        );
      },
    );
  }
}

