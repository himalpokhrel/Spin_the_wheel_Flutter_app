import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WinnerDialog extends StatefulWidget {
  const WinnerDialog({
    super.key,
    required this.winner,
    required this.winnerColor,
  });

  final String winner;
  final Color winnerColor;

  @override
  State<WinnerDialog> createState() => _WinnerDialogState();
}

class _WinnerDialogState extends State<WinnerDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Start confetti when dialog opens
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF252438) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Clean white dialog
        Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Colored accent line at top
                Container(
                  width: 60,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: widget.winnerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Trophy icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.winnerColor.withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 72,
                    color: Colors.amber,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 500.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 300.ms),
                const SizedBox(height: 24),
                // Winner title
                Text(
                  'Winner!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                )
                    .animate(delay: 100.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut)
                    .fadeIn(duration: 300.ms),
                const SizedBox(height: 16),
                // Winner name
                Text(
                  widget.winner,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: widget.winnerColor,
                  ),
                )
                    .animate(delay: 200.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut)
                    .fadeIn(duration: 300.ms),
                const SizedBox(height: 32),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _CleanButton(
                        label: 'Spin Again',
                        onPressed: () => Navigator.pop(context, true),
                        isPrimary: true,
                        color: widget.winnerColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CleanButton(
                        label: 'Close',
                        onPressed: () => Navigator.pop(context, false),
                        isPrimary: false,
                        color: widget.winnerColor,
                      ),
                    ),
                  ],
                )
                    .animate(delay: 300.ms)
                    .slideY(begin: 0.3, end: 0, duration: 400.ms, curve: Curves.easeOut)
                    .fadeIn(duration: 300.ms),
              ],
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              duration: 400.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 300.ms),
        // Confetti overlay
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 30,
          gravity: 0.3,
          emissionFrequency: 0.05,
          colors: [
            widget.winnerColor,
            widget.winnerColor.withValues(alpha: 0.7),
            widget.winnerColor.withValues(alpha: 0.5),
            Colors.amber,
            Colors.white,
          ],
          createParticlePath: (size) {
            final path = Path();
            path.addOval(Rect.fromCircle(center: Offset.zero, radius: size.width / 2));
            return path;
          },
        ),
      ],
    );
  }
}

class _CleanButton extends StatefulWidget {
  const _CleanButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
    required this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color color;

  @override
  State<_CleanButton> createState() => _CleanButtonState();
}

class _CleanButtonState extends State<_CleanButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? widget.color
                : (isDark 
                    ? Colors.white.withValues(alpha: 0.1) 
                    : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: isDark 
                        ? Colors.white.withValues(alpha: 0.2)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: widget.isPrimary
                  ? Colors.white
                  : (isDark ? Colors.white : const Color(0xFF1A1A2E)),
            ),
          ),
        ),
      ),
    );
  }
}
