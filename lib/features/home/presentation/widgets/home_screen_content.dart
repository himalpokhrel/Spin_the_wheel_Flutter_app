import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/haptics_helper.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../wheel/data/constants/default_wheels.dart';
import '../../../wheel/domain/entities/wheel.dart';
import '../../../wheel/presentation/pages/create_wheel_page.dart';
import '../../../wheel/presentation/pages/wheel_spin_page.dart';
import '../../../wheel/presentation/providers/wheel_repository_provider.dart';
import '../../../wheel/presentation/widgets/spin_wheel_widget.dart';
import '../../../wheel/presentation/widgets/wheel_painter.dart';

class HomeScreenContent extends ConsumerWidget {
  const HomeScreenContent({super.key});

  static const _uuid = Uuid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wheelsAsync = ref.watch(wheelsListProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return wheelsAsync.when(
      data: (userWheels) {
        if (isDesktop) {
          return _buildDesktopLayout(context, ref, userWheels);
        } else {
          return _buildMobileLayout(context, ref, userWheels);
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load wheels',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WidgetRef ref,
    List<Wheel> userWheels,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left section - Create a Wheel
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: _buildCreateSection(context, ref),
          ),
        ),
        const VerticalDivider(width: 1),
        // Right section - My Wheels
        Expanded(
          flex: 1,
          child: _buildMyWheelsSection(context, ref, userWheels),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WidgetRef ref,
    List<Wheel> userWheels,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCreateSection(context, ref),
          const Divider(height: 1),
          SizedBox(
            height: 400, // Fixed height for mobile wheel list section
            child: _buildMyWheelsSection(context, ref, userWheels),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateSection(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create a Wheel',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          // Large wheel preview using the first default template
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SpinWheelWidget(
              items: DefaultWheels.templates[0].items,
              size: 320,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              final settings = ref.read(settingsProvider);
              HapticsHelper.lightImpact(settings.hapticEnabled);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateWheelPage(),
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('Create New Wheel'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyWheelsSection(
    BuildContext context,
    WidgetRef ref,
    List<Wheel> userWheels,
  ) {
    final allWheels = [...DefaultWheels.templates, ...userWheels];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Text(
            'My Wheels',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        if (allWheels.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.album_outlined,
                    size: 64,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No wheels yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create your first wheel to get started',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              itemCount: allWheels.length,
              itemBuilder: (context, index) {
                return _buildWheelListItem(context, ref, allWheels[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildWheelListItem(BuildContext context, WidgetRef ref, Wheel wheel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () {
          final settings = ref.read(settingsProvider);
          HapticsHelper.lightImpact(settings.hapticEnabled);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WheelSpinPage(wheel: wheel),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Small wheel thumbnail using CustomPaint with WheelPainter
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomPaint(
                  size: const Size(60, 60),
                  painter: WheelPainter(items: wheel.items),
                ),
              ),
              const SizedBox(width: 16),
              // Wheel name and item count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wheel.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${wheel.items.length} items',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                iconColor: AppColors.textSecondary,
                tooltip: 'More options',
                onSelected: (value) async {
                  final settings = ref.read(settingsProvider);
                  HapticsHelper.lightImpact(settings.hapticEnabled);

                  if (value == 'edit') {
                    // Handle default templates: create a copy instead of editing the template
                    final isTemplate = wheel.id.startsWith('template_');

                    Wheel wheelToEdit;
                    if (isTemplate) {
                      // Create a copy of the template with a new ID and name
                      wheelToEdit = wheel.copyWith(
                        id: _uuid.v4(),
                        name: 'My ${wheel.name}',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                    } else {
                      wheelToEdit = wheel;
                    }

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateWheelPage(wheel: wheelToEdit),
                      ),
                    );
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, ref, wheel);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 12),
                        Text('Edit Wheel'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.error,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Delete Wheel',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Wheel wheel,
  ) {
    // Don't allow deleting built-in templates
    final isTemplate = wheel.id.startsWith('template_');

    if (isTemplate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Built-in templates cannot be deleted'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Wheel?'),
        content: const Text(
          'Are you sure you want to delete this wheel? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // Haptic feedback on delete
              final settings = ref.read(settingsProvider);
              HapticsHelper.lightImpact(settings.hapticEnabled);

              try {
                final deleteWheelUseCase = ref.read(deleteWheelProvider);
                await deleteWheelUseCase(wheel.id);

                // Refresh the wheels list
                ref.invalidate(wheelsListProvider);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${wheel.name} deleted')),
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
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
