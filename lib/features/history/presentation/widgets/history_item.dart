import 'package:flutter/material.dart';
import '../../data/models/history_model.dart';

class HistoryItem extends StatelessWidget {
  final HistoryModel item;
  final String dateStr;
  final void Function() onDelete;

  const HistoryItem({
    super.key,
    required this.item,
    required this.dateStr,
    required this.onDelete,
  });

  static IconData iconForProfile(String profileType) {
    switch (profileType.toLowerCase()) {
      case 'baby':
      case 'bébé':
        return Icons.child_care;
      case 'dog':
      case 'chien':
        return Icons.pets;
      case 'cat':
      case 'chat':
        return Icons.cruelty_free;
      case 'goldfish':
      case 'poissonrouge':
        return Icons.set_meal;
      default:
        return Icons.record_voice_over;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('history_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: Icon(
              iconForProfile(item.profileType),
              color: Theme.of(context).primaryColor,
            ),
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
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
