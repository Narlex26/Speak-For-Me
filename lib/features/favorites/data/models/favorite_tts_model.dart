import 'dart:convert';

class FavoriteTTSModel {
  final String id;
  final String text;
  final String profileType;
  final DateTime createdAt;

  FavoriteTTSModel({
    required this.id,
    required this.text,
    required this.profileType,
    required this.createdAt,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'profileType': profileType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory FavoriteTTSModel.fromJson(Map<String, dynamic> json) {
    return FavoriteTTSModel(
      id: json['id'] as String,
      text: json['text'] as String,
      profileType: json['profileType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Create from JSON string
  factory FavoriteTTSModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return FavoriteTTSModel.fromJson(json);
  }

  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  @override
  String toString() {
    return 'FavoriteTTSModel(id: $id, text: $text, profileType: $profileType, createdAt: $createdAt)';
  }
}
