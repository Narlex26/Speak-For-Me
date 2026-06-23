import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../data/datasources/history_local_datasource.dart';
import '../../data/datasources/history_exporter.dart';
import '../../data/models/history_model.dart';
import '../widgets/history_item.dart';

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
    setState(() => _historyList.removeAt(index));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Supprimé de l\'historique'), duration: Duration(seconds: 1)),
      );
    }
  }

  Future<void> _exportHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Télécharger l\'historique'),
        content: const Text('Voulez-vous télécharger l\'historique des traductions en fichier texte ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Télécharger')),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      await HistoryExporter.export(_historyList);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fichier sauvegardé dans Téléchargements'), duration: Duration(seconds: 3)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'export : $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vider l\'historique'),
        content: const Text('Êtes-vous sûr de vouloir supprimer tout l\'historique ? Cette action est irréversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Vider'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _dataSource.clearAllHistory();
      setState(() => _historyList.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (_historyList.isNotEmpty) ...[
            IconButton(icon: const Icon(Icons.download_rounded), onPressed: _exportHistory, tooltip: 'Exporter en .txt'),
            IconButton(icon: const Icon(Icons.delete_sweep), onPressed: _clearAll, tooltip: 'Vider l\'historique'),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _historyList.isEmpty
              ? const Center(child: Text('Aucun historique pour le moment.', style: TextStyle(fontSize: 16, color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _historyList.length,
                  itemBuilder: (context, index) {
                    final item = _historyList[index];
                    final dateStr = DateFormat('dd MMM yyyy à HH:mm', 'fr_FR').format(item.timestamp);
                    return HistoryItem(
                      item: item,
                      dateStr: dateStr,
                      onDelete: () { if (item.id != null) _deleteItem(index, item.id!); },
                    );
                  },
                ),
    );
  }
}
