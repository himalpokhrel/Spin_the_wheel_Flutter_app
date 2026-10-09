import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/haptics_helper.dart';
import '../../../history/domain/entities/spin_history.dart';
import '../../../history/presentation/providers/history_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/wheel.dart';
import '../../domain/entities/wheel_item.dart';
import '../widgets/spin_wheel_widget.dart';
import '../widgets/winner_dialog.dart';

class WheelSpinPage extends ConsumerStatefulWidget {
  const WheelSpinPage({
    super.key,
    required this.wheel,
  });

  final Wheel wheel;

  @override
  ConsumerState<WheelSpinPage> createState() => _WheelSpinPageState();
}

class _WheelSpinPageState extends ConsumerState<WheelSpinPage> {
  static const _uuid = Uuid();
  final GlobalKey<SpinWheelWidgetState> _wheelKey = GlobalKey();
  late List<WheelItem> _activeItems;

  @override
  void initState() {
    super.initState();
    _activeItems = widget.wheel.items.toList();
  }

  List<WheelItem> get _originalItems => widget.wheel.items;

  void _resetWheel() {
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    setState(() {
      _activeItems = _originalItems.toList();
    });
  }

  Future<void> _onWinner(WheelItem winner) async {
    // Save history entry
    try {
      final historyEntry = SpinHistory(
        id: _uuid.v4(),
        wheelId: widget.wheel.id,
        wheelName: widget.wheel.name,
        winnerTitle: winner.title,
        winnerColor: winner.color,
        timestamp: DateTime.now(),
      );

      final saveHistoryUseCase = ref.read(saveHistoryEntryProvider);
      await saveHistoryUseCase(historyEntry);

      // Invalidate history list to refresh
      ref.invalidate(historyListProvider);
    } catch (e) {
      // Don't block the winner dialog if save fails
      debugPrint('Failed to save history: $e');
    }

    // Show winner dialog
    if (mounted) {
      await showDialog(
        context: context,
        builder: (context) => WinnerDialog(
          winner: winner.title,
          winnerColor: winner.color,
        ),
      );
      
      // Remove winner if the setting is enabled
      if (widget.wheel.removeWinner && mounted) {
        setState(() {
          _activeItems = _activeItems.where((item) => item.id != winner.id).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSpin = _activeItems.length > 1;
    final allWinnersPicked = widget.wheel.removeWinner && _activeItems.length <= 1;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.wheel.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.wheel.removeWinner && _activeItems.length < _originalItems.length)
                Container(
                  margin: const EdgeInsets.only(bottom: 24.0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${_activeItems.length} / ${_originalItems.length} items remaining',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              if (allWinnersPicked)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Text(
                    'All winners picked! Reset the wheel to spin again',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Text(
                  'Tap the wheel to spin!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .fadeIn(duration: 1000.ms)
                    .fadeOut(delay: 1000.ms, duration: 1000.ms),
              const SizedBox(height: 32),
              SpinWheelWidget(
                key: _wheelKey,
                items: _activeItems,
                size: 300,
                onWinner: _onWinner,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CleanButton(
                    onPressed: canSpin
                        ? () {
                            // Haptic feedback on button press
                            final settings = ref.read(settingsProvider);
                            HapticsHelper.lightImpact(settings.hapticEnabled);

                            _wheelKey.currentState?.spin();
                          }
                        : null,
                    icon: Icons.sync,
                    label: 'SPIN',
                    isPrimary: true,
                  ),
                  if (widget.wheel.removeWinner && _activeItems.length < _originalItems.length) ...[
                    const SizedBox(width: 16),
                    _CleanButton(
                      onPressed: _resetWheel,
                      icon: Icons.refresh,
                      label: 'RESET',
                      isPrimary: false,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CleanButton extends StatefulWidget {
  const _CleanButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.isPrimary,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool isPrimary;

  @override
  State<_CleanButton> createState() => _CleanButtonState();
}

class _CleanButtonState extends State<_CleanButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed!();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (widget.onPressed == null 
                    ? Colors.grey.shade400 
                    : AppColors.primary)
                : (isDark 
                    ? AppColors.darkCard 
                    : Colors.white),
            borderRadius: BorderRadius.circular(28),
            border: !widget.isPrimary
                ? Border.all(
                    color: isDark 
                        ? AppColors.darkDivider 
                        : AppColors.divider,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: widget.isPrimary 
                    ? Colors.white 
                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.isPrimary 
                      ? Colors.white 
                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
