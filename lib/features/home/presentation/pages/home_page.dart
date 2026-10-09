import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/haptics_helper.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/home_screen_content.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreenContent(),
      const HistoryPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spin Wheel'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Haptic feedback
              final settings = ref.read(settingsProvider);
              HapticsHelper.lightImpact(settings.hapticEnabled);
              
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          // Haptic feedback on tab switch
          final settings = ref.read(settingsProvider);
          HapticsHelper.selectionClick(settings.hapticEnabled);
          
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }
}