import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/haptics_helper.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/constants/default_wheels.dart';
import '../../data/models/wheel_model.dart';
import '../../domain/entities/wheel.dart';
import '../providers/wheel_repository_provider.dart';
import 'create_wheel_page.dart';
import 'wheel_spin_page.dart';

class WheelListPage extends ConsumerWidget {
  const WheelListPage({super.key});

  static const _uuid = Uuid();

  Future<void> _navigateToCreateWheel(BuildContext context, WidgetRef ref) async {
    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateWheelPage(),
      ),
    );
  }

  Future<void> _useTemplate(
    BuildContext context,
    WidgetRef ref,
    Wheel template,
  ) async {
    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    // Create a new wheel based on template with custom name
    final customizedWheel = template.copyWith(
      id: _uuid.v4(),
      name: 'My ${template.name}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateWheelPage(wheel: customizedWheel),
      ),
    );
  }

  Future<void> _spinTemplate(
    BuildContext context,
    WidgetRef ref,
    Wheel template,
  ) async {
    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WheelSpinPage(wheel: template),
      ),
    );
  }

  Future<void> _navigateToEditWheel(
    BuildContext context,
    WidgetRef ref,
    Wheel wheel,
  ) async {
    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateWheelPage(wheel: wheel),
      ),
    );
  }

  Future<void> _duplicateWheel(
    BuildContext context,
    WidgetRef ref,
    Wheel wheel,
  ) async {
    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    try {
      final now = DateTime.now();
      final duplicatedWheel = wheel.copyWith(
        id: _uuid.v4(),
        name: 'Copy of ${wheel.name}',
        createdAt: now,
        updatedAt: now,
      );

      final saveWheelUseCase = ref.read(saveWheelProvider);
      await saveWheelUseCase(duplicatedWheel);

      // Refresh the list
      ref.invalidate(wheelsListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wheel duplicated successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to duplicate wheel: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteWheel(
    BuildContext context,
    WidgetRef ref,
    Wheel wheel,
  ) async {
    // Haptic feedback for initiating delete
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Wheel'),
        content: Text('Are you sure you want to delete "${wheel.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final deleteWheelUseCase = ref.read(deleteWheelProvider);
      await deleteWheelUseCase(wheel.id);

      // Refresh the list
      ref.invalidate(wheelsListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${wheel.name} deleted'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete wheel: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _exportWheel(
    BuildContext context,
    WidgetRef ref,
    Wheel wheel,
  ) async {
    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    try {
      // Convert wheel to JSON
      final wheelModel = WheelModel.fromEntity(wheel);
      final jsonMap = wheelModel.toJson();
      
      // Format JSON with indentation
      const encoder = JsonEncoder.withIndent('  ');
      final jsonString = encoder.convert(jsonMap);
      
      // Share the JSON
      await Share.share(
        jsonString,
        subject: wheel.name,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wheel exported successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to export wheel: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wheelsAsync = ref.watch(wheelsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wheels'),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCreateWheel(context, ref),
        child: const Icon(Icons.add),
      ),
      body: wheelsAsync.when(
        data: (wheels) {
          return CustomScrollView(
            slivers: [
              // Templates section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Quick Start Templates',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                ),
              ),
              
              // Template cards grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final template = DefaultWheels.templates[index];
                      return _buildTemplateCard(context, ref, template, index);
                    },
                    childCount: DefaultWheels.templates.length,
                  ),
                ),
              ),

              // Divider
              if (wheels.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    child: Divider(
                      color: AppColors.divider,
                      thickness: 1,
                    ),
                  ),
                ),

              // User wheels section
              if (wheels.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.album_outlined,
                            color: AppColors.secondary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'My Wheels',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

              // User wheels list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final wheel = wheels[index];
                      return _buildWheelCard(context, ref, wheel, index);
                    },
                    childCount: wheels.length,
                  ),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load wheels',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => ref.invalidate(wheelsListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    WidgetRef ref,
    Wheel template,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _spinTemplate(context, ref, template),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Template',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${template.items.length} items',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                          ),
                        ),
                      ],
                    ),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _useTemplate(context, ref, template),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Customize',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms, delay: (index * 50).ms)
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1, 1),
            duration: 300.ms,
            delay: (index * 50).ms,
          ),
    );
  }

  Widget _buildWheelCard(
    BuildContext context,
    WidgetRef ref,
    Wheel wheel,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => WheelSpinPage(wheel: wheel),
          ),
        );
      },
      onLongPress: () => _duplicateWheel(context, ref, wheel),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
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
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: AppColors
                      .wheelColors[index % AppColors.wheelColors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wheel.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${wheel.items.length} items',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.content_copy),
                onPressed: () => _duplicateWheel(context, ref, wheel),
                tooltip: 'Duplicate',
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () => _exportWheel(context, ref, wheel),
                tooltip: 'Share',
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _navigateToEditWheel(context, ref, wheel),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                onPressed: () => _deleteWheel(context, ref, wheel),
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 300.ms, delay: (index * 100).ms)
          .slideX(
            begin: 0.2,
            end: 0,
            duration: 300.ms,
            delay: (index * 100).ms,
          ),
    );
  }
}
