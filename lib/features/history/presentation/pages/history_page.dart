import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
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

  Future<void> _exportHistory() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Télécharger l\'historique'),
        content: const Text(
          'Voulez-vous télécharger l\'historique des traductions en fichier texte ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Télécharger'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final dateFormatter = DateFormat('dd MMM yyyy à HH:mm', 'fr_FR');
    final exportDate = DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR').format(DateTime.now());

    final buffer = StringBuffer();
    buffer.writeln('Speak For Me — Historique des traductions');
    buffer.writeln('Exporté le $exportDate');
    buffer.writeln('=' * 42);
    buffer.writeln();

    for (final item in _historyList) {
      buffer.writeln('[${item.profileType}] ${dateFormatter.format(item.timestamp)}');
      buffer.writeln(item.translatedText);
      buffer.writeln();
    }

    buffer.writeln('=' * 42);
    buffer.writeln('${_historyList.length} traduction(s) au total');

    try {
      final content = buffer.toString();
      final bytes = utf8.encode(content);

      if (Platform.isAndroid) {
        const channel = MethodChannel('com.example.speak_for_me/file_saver');
        await channel.invokeMethod('saveToDownloads', {
          'fileName': 'historique_speak_for_me.txt',
          'content': Uint8List.fromList(bytes),
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fichier sauvegardé dans Téléchargements'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/historique_speak_for_me.txt');
        await file.writeAsBytes(bytes);
        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'text/plain')],
          subject: 'Historique Speak For Me',
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'export : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
          if (_historyList.isNotEmpty) ...[
            IconButton(
              icon: const Icon(Icons.download_rounded),
              onPressed: _exportHistory,
              tooltip: 'Exporter en .txt',
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAll,
              tooltip: 'Vider l\'historique',
            ),
          ],
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