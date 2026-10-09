import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/sound_manager.dart';

final soundManagerProvider = Provider<SoundManager>((ref) {
  final manager = SoundManager();
  manager.init();
  
  // Dispose when provider is destroyed
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});
