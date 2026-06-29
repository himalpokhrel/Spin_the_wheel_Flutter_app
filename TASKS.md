# Spin Wheel Project Tasks

A granular, step-by-step checklist to build the Spin Wheel Flutter application using Clean Architecture, Riverpod, and Material 3.

---

## Phase 1: Setup & Dependencies
- [ ] Task 1.1: Add required packages (`flutter_riverpod`, `confetti`, `audioplayers`, `path_provider`, `share_plus`) to `pubspec.yaml` and run `flutter pub get`.
- [ ] Task 1.2: Create Clean Architecture folder structure:
  - `lib/core` (theme, utils, errors, navigation)
  - `lib/features/wheel` (domain, data, presentation)
  - `lib/features/history` (domain, data, presentation)
  - `lib/features/settings` (domain, data, presentation)
- [ ] Task 1.3: Initialize Riverpod `ProviderScope` in `lib/main.dart` and remove default boilerplate counter code.
- [ ] Task 1.4: Define the Material 3 app theme schemes (light and dark mode colors) in `lib/core/theme/app_theme.dart`.

## Phase 2: Core Utilities
- [ ] Task 2.1: Create sound manager helper utilizing `audioplayers` package in `lib/core/utils/sound_manager.dart`.
- [ ] Task 2.2: Create haptic feedback wrapper in `lib/core/utils/haptics_helper.dart`.

## Phase 3: Domain Layer (Entities & Interfaces)
- [ ] Task 3.1: Create `WheelItem` entity model containing `id`, `name`, `weight`, and hex `color` string in `lib/features/wheel/domain/entities/wheel_item.dart`.
- [ ] Task 3.2: Create `Wheel` entity model containing `id`, `name`, and list of `WheelItem`s in `lib/features/wheel/domain/entities/wheel.dart`.
- [ ] Task 3.3: Create `SpinHistory` entity model containing `id`, `wheelId`, `wheelName`, `landedItemName`, `timestamp` in `lib/features/history/domain/entities/spin_history.dart`.
- [ ] Task 3.4: Create the abstract `WheelRepository` interface defining database operations in `lib/features/wheel/domain/repositories/wheel_repository.dart`.
- [ ] Task 3.5: Create the abstract `HistoryRepository` interface defining database operations in `lib/features/history/domain/repositories/history_repository.dart`.
- [ ] Task 3.6: Create the use case for fetching all wheels in `lib/features/wheel/domain/usecases/get_wheels.dart`.
- [ ] Task 3.7: Create the use case for adding a wheel in `lib/features/wheel/domain/usecases/add_wheel.dart`.
- [ ] Task 3.8: Create the use case for updating an existing wheel in `lib/features/wheel/domain/usecases/update_wheel.dart`.
- [ ] Task 3.9: Create the use case for deleting a wheel in `lib/features/wheel/domain/usecases/delete_wheel.dart`.
- [ ] Task 3.10: Create the use case for retrieving history logs in `lib/features/history/domain/usecases/get_history.dart`.
- [ ] Task 3.11: Create the use case for saving a new history record in `lib/features/history/domain/usecases/save_history.dart`.

## Phase 4: Data Layer (Serialization & Repository Implementations)
- [ ] Task 4.1: Implement JSON conversion serialization methods for `WheelItemModel` in `lib/features/wheel/data/models/wheel_item_model.dart`.
- [ ] Task 4.2: Implement JSON conversion serialization methods for `WheelModel` in `lib/features/wheel/data/models/wheel_model.dart`.
- [ ] Task 4.3: Implement JSON conversion serialization methods for `SpinHistoryModel` in `lib/features/history/data/models/spin_history_model.dart`.
- [ ] Task 4.4: Create `WheelLocalDataSource` interface and implementation using `shared_preferences` or local storage files in `lib/features/wheel/data/datasources/wheel_local_data_source.dart`.
- [ ] Task 4.5: Create `HistoryLocalDataSource` interface and implementation using local storage files in `lib/features/history/data/datasources/history_local_data_source.dart`.
- [ ] Task 4.6: Implement repository repository wrapper `WheelRepositoryImpl` in `lib/features/wheel/data/repositories/wheel_repository_impl.dart`.
- [ ] Task 4.7: Implement repository repository wrapper `HistoryRepositoryImpl` in `lib/features/history/data/repositories/history_repository_impl.dart`.

## Phase 5: Presentation Layer - Settings Screen
- [ ] Task 5.1: Create settings Riverpod controller (Dark mode, sounds, haptics) in `lib/features/settings/presentation/providers/settings_provider.dart`.
- [ ] Task 5.2: Create Settings page UI with switch components in `lib/features/settings/presentation/pages/settings_page.dart`.

## Phase 6: Presentation Layer - Wheel Lists & Editor (CRUD)
- [ ] Task 6.1: Create Wheel List state controller utilizing Riverpod in `lib/features/wheel/presentation/providers/wheel_list_provider.dart`.
- [ ] Task 6.2: Create the Wheels List page UI showing saved wheels in `lib/features/wheel/presentation/pages/wheel_list_page.dart`.
- [ ] Task 6.3: Implement Wheel Editor page UI where users can edit name, adjust colors, and configure items in `lib/features/wheel/presentation/pages/wheel_editor_page.dart`.
- [ ] Task 6.4: Implement a text parser modal within the editor to import lists of items from comma or newline-separated names.

## Phase 7: Presentation Layer - Interactive Spin Wheel
- [ ] Task 7.1: Implement custom circular wheel canvas painter `WheelPainter` in `lib/features/wheel/presentation/widgets/wheel_painter.dart`.
- [ ] Task 7.2: Create pointer indicator UI widget in `lib/features/wheel/presentation/widgets/wheel_pointer.dart`.
- [ ] Task 7.3: Build parent interactive spinning container `SpinWheelWidget` in `lib/features/wheel/presentation/widgets/spin_wheel_widget.dart` handling drag, friction deceleration, and sound ticks.
- [ ] Task 7.4: Add slice crossing logic to trigger haptic feedback and ticking sound effects.

## Phase 8: Presentation Layer - Winner Presentation
- [ ] Task 8.1: Create winner dialog overlay inside `lib/features/wheel/presentation/widgets/winner_dialog.dart`.
- [ ] Task 8.2: Implement confetti burst widget overlay using `confetti` package in the spinner screen.
- [ ] Task 8.3: Connect spinner completed callback state to save the spin outcome into history database repository.

## Phase 9: Presentation Layer - History Logs & Statistics
- [ ] Task 9.1: Build history list state controller using Riverpod in `lib/features/history/presentation/providers/history_provider.dart`.
- [ ] Task 9.2: Create History log page displaying all spin records in `lib/features/history/presentation/pages/history_page.dart`.
- [ ] Task 9.3: Create statistics analytics page showing landed frequency rates of slices in `lib/features/history/presentation/pages/statistics_page.dart`.

## Phase 10: Import/Export Features
- [ ] Task 10.1: Build JSON exporter helper function in `lib/features/wheel/presentation/providers/wheel_export_provider.dart`.
- [ ] Task 10.2: Implement Import Wheel from Clipboard string text field dialog.

## Phase 11: Final Assembly & Compilation
- [ ] Task 11.1: Build base landing scaffold navigation shell (Tabs: Wheels, Spin, History, Settings) in `lib/features/home/presentation/pages/home_page.dart`.
- [ ] Task 11.2: Verify compiling, build structure integrity, and state consistency on Android and iOS.
