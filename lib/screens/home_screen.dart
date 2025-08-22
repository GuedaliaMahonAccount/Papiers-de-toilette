import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/paper_controller.dart';
import '../models/paper_models.dart';
import '../widgets/paper_segment.dart';
import '../widgets/cut_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PaperController _controller = PaperController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _touchAnimationController;
  late Animation<double> _touchAnimation;

  @override
  void initState() {
    super.initState();

    _touchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _touchAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _touchAnimationController,
      curve: Curves.easeInOut,
    ));

    // Optionally jump to top on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pixels = _scrollController.positions.isNotEmpty
          ? _scrollController.position.pixels
          : 0.0;
      final viewport = _scrollController.positions.isNotEmpty
          ? _scrollController.position.viewportDimension
          : MediaQuery.of(context).size.height;
      _controller.onScroll(pixels, viewport);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _touchAnimationController.dispose();
    super.dispose();
  }

  void _handleCut() {
    // Reset model
    _controller.handleCut();
    // Jump scroll back to top
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
    // Also tell controller its new scroll offset is 0
    _controller.resetScrollPosition();
  }

  void _handlePanStart(DragStartDetails details) {
    _touchAnimationController.forward();
    // Light haptic feedback when starting to scroll
    HapticFeedback.selectionClick();
  }

  void _handlePanEnd(DragEndDetails details) {
    _touchAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paper Roll',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE2C9A7),
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: [
          // Dirt level indicator
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final dirtiness = _controller.averageDirtiness;

              return Container(
                margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      size: 16,
                      color: Color.lerp(
                        Colors.green,
                        Colors.brown,
                        dirtiness,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 30,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: dirtiness.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: Color.lerp(
                              Colors.green,
                              Colors.brown,
                              dirtiness.clamp(0.0, 1.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ScaleTransition(
            scale: _touchAnimation,
            child: GestureDetector(
              onPanStart: _handlePanStart,
              onPanEnd: _handlePanEnd,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.axis == Axis.vertical) {
                    // --- IMPORTANT: on passe la vraie hauteur du viewport
                    _controller.onScroll(
                      notification.metrics.pixels,
                      notification.metrics.viewportDimension,
                    );
                  }
                  return false; // allow list to continue handling
                },
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return Stack(
                      children: [
                        // Liste principale
                        ListView.builder(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: PaperController.totalSegments,
                          itemBuilder: (context, index) {
                            final PaperSegment seg = _controller.getOrCreateSegment(index);
                            return PaperSegmentWidget(
                              key: ValueKey('segment_$index'),
                              segment: seg,
                              height: PaperController.segmentHeight,
                              showPerforation: true,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: CutFab(onCut: _handleCut),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
