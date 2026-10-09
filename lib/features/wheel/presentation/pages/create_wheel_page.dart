import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/haptics_helper.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/wheel.dart';
import '../providers/wheel_editor_provider.dart';
import '../providers/wheel_editor_state.dart';
import '../providers/wheel_repository_provider.dart';

class CreateWheelPage extends ConsumerStatefulWidget {
  const CreateWheelPage({
    super.key,
    this.wheel,
  });

  final Wheel? wheel;

  @override
  ConsumerState<CreateWheelPage> createState() => _CreateWheelPageState();
}

class _CreateWheelPageState extends ConsumerState<CreateWheelPage> {
  final TextEditingController _wheelNameController = TextEditingController();
  final List<TextEditingController> _itemControllers = [];
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with current state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load wheel if editing
      if (widget.wheel != null) {
        ref.read(wheelEditorProvider.notifier).loadWheel(
              widget.wheel!.id,
              widget.wheel!.name,
              widget.wheel!.items,
              removeWinner: widget.wheel!.removeWinner,
            );
      }
      
      final editorState = ref.read(wheelEditorProvider);
      _wheelNameController.text = editorState.name;
      
      for (final item in editorState.items) {
        final controller = TextEditingController(text: item.title);
        controller.addListener(() => _syncControllersToState());
        _itemControllers.add(controller);
      }
    });
  }

  @override
  void dispose() {
    _wheelNameController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _syncControllersToState() {
    final editorState = ref.read(wheelEditorProvider);
    
    // Sync wheel name
    if (_wheelNameController.text != editorState.name) {
      ref.read(wheelEditorProvider.notifier).setName(_wheelNameController.text);
    }
    
    // Sync item titles
    for (int i = 0; i < _itemControllers.length && i < editorState.items.length; i++) {
      if (_itemControllers[i].text != editorState.items[i].title) {
        ref.read(wheelEditorProvider.notifier).updateItem(i, _itemControllers[i].text);
      }
    }
  }

  void _addItem() {
    final editorState = ref.read(wheelEditorProvider);
    
    if (editorState.items.length >= WheelEditorState.maxItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum ${WheelEditorState.maxItems} items allowed'),
        ),
      );
      return;
    }
    
    // Haptic feedback on add
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    ref.read(wheelEditorProvider.notifier).addItem();
    
    // Add controller for the new item
    final newItem = ref.read(wheelEditorProvider).items.last;
    final controller = TextEditingController(text: newItem.title);
    controller.addListener(() => _syncControllersToState());
    setState(() {
      _itemControllers.add(controller);
    });
  }

  void _removeItem(int index) {
    final editorState = ref.read(wheelEditorProvider);
    
    if (editorState.items.length <= WheelEditorState.minItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least ${WheelEditorState.minItems} items are required'),
        ),
      );
      return;
    }
    
    // Haptic feedback on remove
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    ref.read(wheelEditorProvider.notifier).removeItem(index);
    
    setState(() {
      _itemControllers[index].dispose();
      _itemControllers.removeAt(index);
    });
  }

  void _updateItemColor(int index, Color color) {
    // Haptic feedback on color change
    final settings = ref.read(settingsProvider);
    HapticsHelper.selectionClick(settings.hapticEnabled);
    
    ref.read(wheelEditorProvider.notifier).updateItemColor(index, color);
  }

  List<Color> _getPresetColors() {
    return [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
      Colors.cyan,
      Colors.indigo,
      Colors.lime,
      Colors.deepOrange,
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
    ];
  }

  void _showColorPicker(int index) {
    final editorState = ref.read(wheelEditorProvider);
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Color',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _getPresetColors().length,
                itemBuilder: (context, colorIndex) {
                  final color = _getPresetColors()[colorIndex];
                  return GestureDetector(
                    onTap: () {
                      _updateItemColor(index, color);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: editorState.items[index].color == color
                              ? AppColors.textPrimary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    final editorState = ref.read(wheelEditorProvider);
    
    if (!editorState.isValid) return;
    
    // Haptic feedback on save
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);
    
    try {
      final now = DateTime.now();
      final wheel = Wheel(
        id: editorState.editingWheelId ?? _uuid.v4(),
        name: editorState.name,
        items: editorState.items,
        createdAt: widget.wheel?.createdAt ?? now,
        updatedAt: now,
        removeWinner: editorState.removeWinner,
      );
      
      final saveWheelUseCase = ref.read(saveWheelProvider);
      await saveWheelUseCase(wheel);
      
      // Invalidate wheels list to refresh
      ref.invalidate(wheelsListProvider);
      
      ref.read(wheelEditorProvider.notifier).reset();
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save wheel: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showImportBottomSheet() {
    final TextEditingController importController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Import Items',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: importController,
                maxLines: null,
                minLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pizza, Burger, Pasta...',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Paste item names separated by commas or new lines',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _importItems(importController.text);
                  Navigator.of(context).pop();
                },
                child: const Text('Import'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _importItems(String text) {
    if (text.trim().isEmpty) return;

    // Haptic feedback
    final settings = ref.read(settingsProvider);
    HapticsHelper.lightImpact(settings.hapticEnabled);

    final editorState = ref.read(wheelEditorProvider);
    
    // Bug 1 Fix: Parse all items from text (including \r for Windows)
    final parsedItems = text
        .split(RegExp(r'[,\n\r]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (parsedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid items found'),
        ),
      );
      return;
    }

    // Bug 3 Fix: Check if current items are default placeholders
    final hasDefaultPlaceholders = editorState.items.every((item) {
      final title = item.title.trim();
      return title.startsWith('Option ') && 
             int.tryParse(title.substring(7)) != null;
    });

    // If only placeholders exist, clear them first
    if (hasDefaultPlaceholders && editorState.items.isNotEmpty) {
      // Remove all existing items and controllers
      final itemCount = editorState.items.length;
      for (int i = itemCount - 1; i >= 0; i--) {
        ref.read(wheelEditorProvider.notifier).removeItem(i);
        if (i < _itemControllers.length) {
          _itemControllers[i].dispose();
        }
      }
      setState(() {
        _itemControllers.clear();
      });
    }

    // Bug 2 Fix: Get current item titles to check for duplicates
    final existingTitles = ref.read(wheelEditorProvider)
        .items
        .map((item) => item.title.toLowerCase().trim())
        .toSet();

    // Filter out items that already exist (case-insensitive)
    final itemsToAdd = parsedItems
        .where((title) => !existingTitles.contains(title.toLowerCase().trim()))
        .toList();

    if (itemsToAdd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All items already exist in the wheel'),
        ),
      );
      return;
    }

    // Check if we'll exceed max items
    final currentCount = ref.read(wheelEditorProvider).items.length;
    final totalItems = currentCount + itemsToAdd.length;
    if (totalItems > WheelEditorState.maxItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cannot import all items. Maximum ${WheelEditorState.maxItems} items allowed. '
            'Currently have $currentCount items.',
          ),
        ),
      );
      return;
    }

    // Get preset colors
    final presetColors = _getPresetColors();
    
    // Add each unique item
    int addedCount = 0;
    for (int i = 0; i < itemsToAdd.length; i++) {
      final itemTitle = itemsToAdd[i];
      final color = presetColors[i % presetColors.length];
      
      ref.read(wheelEditorProvider.notifier).addItemWithDetails(
            itemTitle,
            color,
          );
      
      // Add controller
      final newItem = ref.read(wheelEditorProvider).items.last;
      final controller = TextEditingController(text: newItem.title);
      controller.addListener(() => _syncControllersToState());
      setState(() {
        _itemControllers.add(controller);
      });
      
      addedCount++;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$addedCount items imported successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(wheelEditorProvider);
    final isEditing = widget.wheel != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Wheel' : 'Create Wheel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(wheelEditorProvider.notifier).reset();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            onPressed: _showImportBottomSheet,
            tooltip: 'Import Items',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            TextField(
              controller: _wheelNameController,
              decoration: InputDecoration(
                labelText: 'Wheel Name',
                border: const OutlineInputBorder(),
                errorText: editorState.nameError,
              ),
              maxLength: WheelEditorState.maxWheelNameLength,
              onChanged: (value) {
                ref.read(wheelEditorProvider.notifier).setName(value);
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items (${editorState.items.length}/${WheelEditorState.maxItems})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (editorState.itemsError != null)
                  Text(
                    editorState.itemsError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: editorState.items.length,
                itemBuilder: (context, index) {
                  // Ensure we have enough controllers
                  while (_itemControllers.length <= index) {
                    final controller = TextEditingController(
                      text: editorState.items[_itemControllers.length].title,
                    );
                    controller.addListener(() => _syncControllersToState());
                    _itemControllers.add(controller);
                  }
                  
                  final item = editorState.items[index];
                  final itemError = editorState.getItemError(index);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: GestureDetector(
                            onTap: () => _showColorPicker(index),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _itemControllers[index],
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Item title',
                              errorText: itemError,
                            ),
                            maxLength: WheelEditorState.maxItemLabelLength,
                            onChanged: (value) {
                              ref.read(wheelEditorProvider.notifier).updateItem(index, value);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: editorState.items.length > WheelEditorState.minItems
                                ? () => _removeItem(index)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: editorState.items.length < WheelEditorState.maxItems
                  ? _addItem
                  : null,
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Remove Winner After Spin'),
              subtitle: const Text('Winning items are removed from the wheel automatically'),
              value: editorState.removeWinner,
              onChanged: (value) {
                final settings = ref.read(settingsProvider);
                HapticsHelper.selectionClick(settings.hapticEnabled);
                ref.read(wheelEditorProvider.notifier).toggleRemoveWinner();
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: editorState.isValid ? _handleSave : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
