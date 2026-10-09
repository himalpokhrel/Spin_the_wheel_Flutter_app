import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  final AudioPlayer _tickPlayer = AudioPlayer();
  final AudioPlayer _winPlayer = AudioPlayer();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    
    try {
      // Configure players for low latency and quick replay
      await _tickPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _tickPlayer.setReleaseMode(ReleaseMode.stop);
      
      await _winPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _winPlayer.setReleaseMode(ReleaseMode.stop);
      
      // Preload the sounds for faster playback
      await _tickPlayer.setSource(AssetSource('sounds/tick.mp3'));
      await _winPlayer.setSource(AssetSource('sounds/win.mp3'));
      
      _initialized = true;
    } catch (e) {
      // Initialization failed - sounds will be disabled but app continues
      _initialized = false;
    }
  }

  Future<void> playTick(bool soundEnabled) async {
    if (!soundEnabled || !_initialized) return;
    
    try {
      // Stop any current playback and restart from beginning
      await _tickPlayer.stop();
      await _tickPlayer.resume();
    } catch (e) {
      // Silent fail - don't crash the app if sound doesn't play
    }
  }

  Future<void> playWin(bool soundEnabled) async {
    if (!soundEnabled || !_initialized) return;
    
    try {
      // Stop any current playback and restart from beginning
      await _winPlayer.stop();
      await _winPlayer.resume();
    } catch (e) {
      // Silent fail - don't crash the app if sound doesn't play
    }
  }

  void dispose() {
    _tickPlayer.dispose();
    _winPlayer.dispose();
  }
}
