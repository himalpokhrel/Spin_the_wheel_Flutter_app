import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/wheel.dart';
import '../../domain/entities/wheel_item.dart';

/// Default pre-made wheel templates
class DefaultWheels {
  const DefaultWheels._();

  static const _uuid = Uuid();
  static final _baseDate = DateTime(2024);

  /// Creates a wheel item with cycling colors from AppColors.wheelColors
  static WheelItem _createItem(String title, int index) {
    return WheelItem(
      id: _uuid.v4(),
      title: title,
      color: AppColors.wheelColors[index % AppColors.wheelColors.length],
      createdAt: _baseDate,
    );
  }

  /// Creates a wheel with template ID prefix
  static Wheel _createWheel(String name, List<String> itemTitles) {
    final items = itemTitles
        .asMap()
        .entries
        .map((entry) => _createItem(entry.value, entry.key))
        .toList();

    return Wheel(
      id: 'template_${name.toLowerCase().replaceAll(' ', '_')}',
      name: name,
      items: items,
      createdAt: _baseDate,
      updatedAt: _baseDate,
      removeWinner: false,
    );
  }

  /// All default wheel templates
  static final List<Wheel> templates = [
    _createWheel('Yes/No', ['Yes', 'No']),
    _createWheel(
      'What Should I Eat?',
      ['Pizza', 'Burger', 'Pasta', 'Salad', 'Tacos', 'Sushi'],
    ),
    _createWheel('Truth or Dare', ['Truth', 'Dare']),
    _createWheel('Study or Break', ['Study', 'Take a Break']),
    _createWheel(
      'Random Numbers',
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
    ),
    _createWheel(
      'Color Picker',
      ['Red', 'Blue', 'Green', 'Yellow', 'Orange', 'Purple', 'Pink', 'Black'],
    ),
    _createWheel('Decision Maker', ['Yes', 'No', 'Maybe']),
    _createWheel(
      'Party Challenges',
      [
        'Dance',
        'Sing',
        'Tell a joke',
        'Do a dare',
        'Share a story',
        'Skip turn'
      ],
    ),
  ];
}
