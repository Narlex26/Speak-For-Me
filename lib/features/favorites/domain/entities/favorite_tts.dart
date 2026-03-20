class FavoriteTTS {
  final String id;
  final String text;
  final String profileType;
  final DateTime createdAt;

  FavoriteTTS({
    required this.id,
    required this.text,
    required this.profileType,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'FavoriteTTS(id: $id, text: $text, profileType: $profileType, createdAt: $createdAt)';
  }
}
