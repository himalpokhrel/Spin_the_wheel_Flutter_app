class AppSettings {
  final bool isDarkMode;
  final bool soundEnabled;
  final bool hapticEnabled;

  const AppSettings({
    required this.isDarkMode,
    required this.soundEnabled,
    required this.hapticEnabled,
  });

  factory AppSettings.defaultSettings() {
    return const AppSettings(
      isDarkMode: false,
      soundEnabled: true,
      hapticEnabled: true,
    );
  }

  AppSettings copyWith({
    bool? isDarkMode,
    bool? soundEnabled,
    bool? hapticEnabled,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppSettings &&
        other.isDarkMode == isDarkMode &&
        other.soundEnabled == soundEnabled &&
        other.hapticEnabled == hapticEnabled;
  }

  @override
  int get hashCode =>
      isDarkMode.hashCode ^ soundEnabled.hashCode ^ hapticEnabled.hashCode;
}
