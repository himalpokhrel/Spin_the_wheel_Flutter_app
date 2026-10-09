# Sound Assets

This directory contains sound files for the Spin Wheel app.

## Required Files

1. **tick.mp3** - Played on each slice transition during wheel spin
   - Should be a short, subtle tick sound (50-100ms)
   - Recommended: soft click or tick sound

2. **win.mp3** - Played when a winner is determined
   - Should be a celebratory sound (1-2 seconds)
   - Recommended: fanfare, celebration, or success sound

## Current Status

⚠️ **Sound files not yet added** - The app is configured to play these sounds but they are currently placeholder-only. The app will function normally without them (silent mode).

## Adding Sound Files

1. Place `tick.mp3` and `win.mp3` in this directory
2. Rebuild the app (`flutter clean && flutter pub get`)
3. Sounds will automatically play based on user settings

## Implementation Details

- Sounds are managed by `SoundManager` (`lib/core/utils/sound_manager.dart`)
- Sound playback respects user settings (can be toggled in Settings page)
- Uses `audioplayers` package for audio playback
