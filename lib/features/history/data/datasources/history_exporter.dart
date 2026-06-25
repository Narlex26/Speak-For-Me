import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/history_model.dart';

class HistoryExporter {
  static Future<void> export(List<HistoryModel> items) async {
    final dateFormatter = DateFormat('dd MMM yyyy à HH:mm', 'fr_FR');
    final exportDate = DateFormat('dd MMMM yyyy à HH:mm', 'fr_FR').format(DateTime.now());

    final buffer = StringBuffer();
    buffer.writeln('Speak For Me — Historique des traductions');
    buffer.writeln('Exporté le $exportDate');
    buffer.writeln('=' * 42);
    buffer.writeln();

    for (final item in items) {
      buffer.writeln('[${item.profileType}] ${dateFormatter.format(item.timestamp)}');
      buffer.writeln(item.translatedText);
      buffer.writeln();
    }

    buffer.writeln('=' * 42);
    buffer.writeln('${items.length} traduction(s) au total');

    final bytes = utf8.encode(buffer.toString());

    if (Platform.isAndroid) {
      const channel = MethodChannel('com.example.speak_for_me/file_saver');
      await channel.invokeMethod('saveToDownloads', {
        'fileName': 'historique_speak_for_me.txt',
        'content': Uint8List.fromList(bytes),
      });
    } else {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/historique_speak_for_me.txt');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/plain')],
        subject: 'Historique Speak For Me',
      );
    }
  }
}
