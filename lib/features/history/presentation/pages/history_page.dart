import 'package:flutter/material.dart';
import '../../data/datasources/history_local_datasource.dart';
import '../../data/models/history_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryLocalDataSource _dataSource = HistoryLocalDataSource();
  List<HistoryModel> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null).then((_) => _loadHistory());
  }

  Future<void> _loadHistory() async {
    final history = await _dataSource.getRecentHistory();
    setState(() {
      _historyList = history;
      _isLoading = false;
    });
  }

  Future<void> _deleteItem(int index, int id) async {
    await _dataSource.deleteHistory(id);
    setState(() {
      _historyList.removeAt(index);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supprimé de l\'historique'), duration: Duration(seconds: 1)),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Vider l\'historique'),
          content: const Text('Êtes-vous sûr de vouloir supprimer tout l\'historique ? Cette action est irréversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Vider'),
            ),
          ],
        );
      }
    );

    if (confirm == true) {
      await _dataSource.clearAllHistory();
      setState(() {
        _historyList.clear();
      });
    }
  }

  IconData _getIconForProfile(String profileType) {
    switch (profileType.toLowerCase()) {
      case 'baby':
      case 'bébé':
        return Icons.child_care;
      case 'dog':
      case 'chien':
        return Icons.pets;
      case 'cat':
      case 'chat':
        return Icons.cruelty_free; // a standard icon for cat isn't in material icons directly, let's use cruelty_free or another
      case 'goldfish':
      case 'poissonrouge':
        return Icons.set_meal; // or something water related
      default:
        return Icons.record_voice_over;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (_historyList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAll,
              tooltip: 'Vider l\'historique',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun historique pour le moment.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _historyList.length,
                  itemBuilder: (context, index) {
                    final item = _historyList[index];
                    final dateStr = DateFormat('dd MMM yyyy à HH:mm', 'fr_FR').format(item.timestamp);
                    
                    return Dismissible(
                      key: Key('history_${item.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        if (item.id != null) {
                          _deleteItem(index, item.id!);
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                            child: Icon(_getIconForProfile(item.profileType), color: Theme.of(context).primaryColor),
                          ),
                          title: Text(
                            item.translatedText,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '$dateStr • ${item.profileType}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () {
                              if (item.id != null) {
                                _deleteItem(index, item.id!);
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}