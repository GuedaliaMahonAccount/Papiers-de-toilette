import 'package:flutter/material.dart';
import 'dart:math' as math;

class PaperBackgroundWidget extends StatefulWidget {
  final double dirtiness; // 0.0 = clean, 1.0 = dirty
  final double width;
  final double height;
  final int animationSeed; // For consistent but varied animations

  const PaperBackgroundWidget({
    super.key,
    required this.dirtiness,
    required this.width,
    required this.height,
    this.animationSeed = 0,
  });

  @override
  State<PaperBackgroundWidget> createState() => _PaperBackgroundWidgetState();
}

class _PaperBackgroundWidgetState extends State<PaperBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(PaperBackgroundWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Si la page devient sale instantanément (dirtiness = 1.0), pas d'animation
    if (oldWidget.dirtiness != widget.dirtiness) {
      if (widget.dirtiness >= 1.0) {
        // Page sale : pas d'animation, direct à la fin
        _animationController.value = 1.0;
      } else {
        // Page qui se salit progressivement : animation normale
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Si la page est complètement sale, affichage direct sans animation
    if (widget.dirtiness >= 1.0) {
      return Container(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            // Image sale directement, sans transition
            Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/papier_sale.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Effets additionnels pour les pages sales
            _buildDirtParticles(),
            _buildModernOverlay(),
            _buildDepthGradient(),
          ],
        ),
      );
    }
    
    // Sinon, animation normale pour la transition
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              // Clean paper base with slight scaling animation
              Transform.scale(
                scale: 1.0 - (widget.dirtiness * 0.02), // Very subtle scale
                child: Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/papier_propre.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withOpacity(1.0 - widget.dirtiness * 0.2),
                        BlendMode.modulate,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Dirty paper overlay with opacity based on dirtiness
              AnimatedOpacity(
                duration: Duration(milliseconds: 400), // Transition plus rapide
                opacity: widget.dirtiness * _fadeAnimation.value,
                child: Transform.scale(
                  scale: 1.0 + (widget.dirtiness * 0.01), // Very subtle scale
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/papier_sale.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.brown.withOpacity(0.1 + widget.dirtiness * 0.3),
                          BlendMode.multiply,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Additional dirt particles for modern effect
              if (widget.dirtiness > 0.2)
                _buildDirtParticles(),
                
              // Subtle animated overlay for modern effect
              _buildModernOverlay(),
              
              // Gradient overlay for depth
              _buildDepthGradient(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDirtParticles() {
    final random = math.Random(widget.animationSeed);
    final particleCount = (widget.dirtiness * 15).round();
    
    return Stack(
      children: List.generate(particleCount, (index) {
        final x = random.nextDouble() * widget.width;
        final y = random.nextDouble() * widget.height;
        final size = 2.0 + random.nextDouble() * 4.0;
        
        return Positioned(
          left: x,
          top: y,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 400 + index * 50),
            opacity: widget.dirtiness * 0.6 * _fadeAnimation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildModernOverlay() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15 * (1.0 - widget.dirtiness)),
            Colors.transparent,
            Colors.black.withOpacity(0.08 * widget.dirtiness),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
    );
  }
  
  Widget _buildDepthGradient() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.02 * widget.dirtiness),
          ],
        ),
      ),
    );
  }
}
