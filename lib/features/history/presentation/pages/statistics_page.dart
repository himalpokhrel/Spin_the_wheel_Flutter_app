import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/spin_history.dart';
import '../providers/history_provider.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  Map<String, List<SpinHistory>> _groupByWheel(List<SpinHistory> history) {
    final Map<String, List<SpinHistory>> grouped = {};
    for (final entry in history) {
      if (!grouped.containsKey(entry.wheelId)) {
        grouped[entry.wheelId] = [];
      }
      grouped[entry.wheelId]!.add(entry);
    }
    return grouped;
  }

  Map<String, int> _countWinners(List<SpinHistory> wheelHistory) {
    final Map<String, int> counts = {};
    for (final entry in wheelHistory) {
      counts[entry.winnerTitle] = (counts[entry.winnerTitle] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: const Icon(
                      Icons.bar_chart,
                      size: 72,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No statistics yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Spin some wheels!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scale(begin: const Offset(0.8, 0.8), duration: 500.ms),
            );
          }

          final wheelGroups = _groupByWheel(history);

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: wheelGroups.length,
            itemBuilder: (context, wheelIndex) {
              final wheelId = wheelGroups.keys.elementAt(wheelIndex);
              final wheelHistory = wheelGroups[wheelId]!;
              final wheelName = wheelHistory.first.wheelName;
              final totalSpins = wheelHistory.length;

              // Count winners and sort by count descending
              final winnerCounts = _countWinners(wheelHistory);
              final sortedWinners = winnerCounts.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return Container(
                margin: const EdgeInsets.only(bottom: 24.0),
                padding: const EdgeInsets.all(20.0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wheelName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
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
                        '$totalSpins total ${totalSpins == 1 ? 'spin' : 'spins'}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...sortedWinners.map((entry) {
                      final winnerTitle = entry.key;
                      final winCount = entry.value;
                      final percentage =
                          (winCount / totalSpins * 100).toStringAsFixed(1);

                      // Find the color from history
                      final color = wheelHistory
                          .firstWhere((h) => h.winnerTitle == winnerTitle)
                          .winnerColor;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    winnerTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$winCount ${winCount == 1 ? 'win' : 'wins'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$percentage%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: winCount / totalSpins,
                                backgroundColor:
                                    AppColors.textSecondary.withValues(alpha: 0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  color,
                                ),
                                minHeight: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
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
                'Failed to load statistics',
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
                onPressed: () => ref.invalidate(historyListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
