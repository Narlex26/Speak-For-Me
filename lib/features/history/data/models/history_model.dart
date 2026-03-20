class HistoryModel {
  final int? id;
  final String profileType;
  final String translatedText;
  final DateTime timestamp;

  HistoryModel({
    this.id,
    required this.profileType,
    required this.translatedText,
    required this.timestamp,
  });

  HistoryModel copyWith({
    int? id,
    String? profileType,
    String? translatedText,
    DateTime? timestamp,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      profileType: profileType ?? this.profileType,
      translatedText: translatedText ?? this.translatedText,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileType': profileType,
      'translatedText': translatedText,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] as int?,
      profileType: json['profileType'] as String,
      translatedText: json['translatedText'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}