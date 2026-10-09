import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/sound_manager_provider.dart';
import '../../../../core/utils/haptics_helper.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/wheel_item.dart';
import 'wheel_painter.dart';

class SpinWheelWidget extends ConsumerStatefulWidget {
  const SpinWheelWidget({
    super.key,
    required this.items,
    this.size = 300,
    this.onWinner,
  });

  final List<WheelItem> items;
  final double size;
  final ValueChanged<WheelItem>? onWinner;

  @override
  ConsumerState<SpinWheelWidget> createState() => SpinWheelWidgetState();
}

class SpinWheelWidgetState extends ConsumerState<SpinWheelWidget>
    with SingleTickerProviderStateMixin {
  static const double _pointerSize = 20.0;
  static const Duration _spinDuration = Duration(seconds: 4);

  late final AnimationController _controller;
  late Animation<double> _rotationAnimation;

  double _currentAngle = 0;
  bool _isSpinning = false;
  WheelItem? _selectedWinner;
  int _selectedIndex = 0;
  int _lastSliceIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _spinDuration);
    _rotationAnimation = AlwaysStoppedAnimation(_currentAngle);
    
    // Listen to animation to detect slice changes for tick sound/haptic
    _controller.addListener(_onAnimationTick);
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationTick() {
    if (!_isSpinning || widget.items.isEmpty) return;

    final sliceAngle = (2 * math.pi) / widget.items.length;
    final normalizedAngle = _rotationAnimation.value % (2 * math.pi);
    final currentSliceIndex = ((2 * math.pi - normalizedAngle) / sliceAngle).floor() % widget.items.length;

    if (currentSliceIndex != _lastSliceIndex) {
      _lastSliceIndex = currentSliceIndex;
      
      // Play tick sound and haptic feedback on slice transition
      final settings = ref.read(settingsProvider);
      final soundManager = ref.read(soundManagerProvider);
      
      soundManager.playTick(settings.soundEnabled);
      HapticsHelper.lightImpact(settings.hapticEnabled);
    }
  }

  void spin() {
  if (_isSpinning || widget.items.isEmpty) return;

  final random = math.Random();

  // Pick winner FIRST
  _selectedIndex = random.nextInt(widget.items.length);
  _selectedWinner = widget.items[_selectedIndex];

  final sliceAngle = (2 * math.pi) / widget.items.length;

  // Center of the winning slice
  final winnerCenter =
      _selectedIndex * sliceAngle + sliceAngle / 2;

  // Random full rotations
  final spins = 5 + random.nextInt(4);

  // Rotate so winner center reaches top pointer
  final targetRotation =
      spins * 2 * math.pi +
      (2 * math.pi - winnerCenter);

  _rotationAnimation = Tween<double>(
    begin: _currentAngle,
    end: targetRotation,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ),
  );

  setState(() {
    _isSpinning = true;
    _lastSliceIndex = -1; // Reset for new spin
  });

  // Initial haptic feedback when spin starts
  final settings = ref.read(settingsProvider);
  HapticsHelper.selectionClick(settings.hapticEnabled);

  _controller
    ..reset()
    ..forward().whenComplete(() {
      _currentAngle = targetRotation % (2 * math.pi);

      // Play win sound and heavy haptic when winner is determined
      final soundManager = ref.read(soundManagerProvider);
      soundManager.playWin(settings.soundEnabled);
      HapticsHelper.heavyImpact(settings.hapticEnabled);

      if (_selectedWinner != null && widget.onWinner != null) {
        widget.onWinner!(_selectedWinner!);
      }

      setState(() => _isSpinning = false);
    });
}



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: spin,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            RepaintBoundary(
              child: AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: WheelPainter(items: widget.items),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              child: CustomPaint(
                size: const Size(_pointerSize, _pointerSize),
                painter: _PointerPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PointerPainter extends CustomPainter {
  const _PointerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    // Draw black teardrop/droplet pointer
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PointerPainter oldDelegate) => false;
}