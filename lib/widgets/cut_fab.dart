import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CutFab extends StatefulWidget {
  final VoidCallback onCut;

  const CutFab({
    super.key,
    required this.onCut,
  });

  @override
  State<CutFab> createState() => _CutFabState();
}

class _CutFabState extends State<CutFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleCut() async {
    // Trigger haptic feedback
    await HapticFeedback.lightImpact();
    
    // Animate button press
    await _animationController.forward();
    await _animationController.reverse();
    
    // Call the cut callback
    widget.onCut();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B4513).withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _handleCut,
          backgroundColor: const Color(0xFF8B4513), // Brown color for scissors
          foregroundColor: Colors.white,
          elevation: 0, // Remove default elevation since we have custom shadow
          tooltip: 'Cut paper',
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background glow effect
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              // Scissors icon
              const Icon(
                Icons.content_cut,
                size: 28.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
