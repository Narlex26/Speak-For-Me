import 'package:flutter/material.dart';
import '../../data/datasources/statistics_local_datasource.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final StatisticsLocalDataSource _dataSource = StatisticsLocalDataSource();

  int _dailyStreak = 0;
  int _favoritesCount = 0;
  Map<String, int> _translationsPerSpecimen = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final stats = await _dataSource.getStatistics();
    setState(() {
      _dailyStreak = stats['streak'] as int;
      _favoritesCount = stats['favoritesCount'] as int? ?? 0;
      _translationsPerSpecimen = Map<String, int>.from(stats['specimens']);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Statistiques')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistiques'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStreakCard(),
          const SizedBox(height: 16),
          _buildFavoritesCard(),
          const SizedBox(height: 16),
          _buildSpecimenStats(),
        ],
      ),
    );
  }

  Widget _buildStreakCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.local_fire_department, size: 48, color: Colors.orange),
            const SizedBox(height: 8),
            Text(
              '$_dailyStreak Jours de suite !',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text('Continuez à traduire pour maintenir votre streak !'),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.star_rounded, size: 40, color: Colors.amber),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_favoritesCount Phrases',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Text('Sauvegardées dans vos favoris'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecimenStats() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Traductions par spécimen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ..._translationsPerSpecimen.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 16)),
                    Text('${entry.value} traductions', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
