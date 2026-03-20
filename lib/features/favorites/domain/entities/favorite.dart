import 'package:speak_for_me/features/specimen_selection/domain/entities/specimen.dart';

class FavoriteTranslation {
  final ProfileType profileType;
  final String phrase;
  final DateTime date;

  FavoriteTranslation({
    required this.profileType,
    required this.phrase,
    required this.date,
  });

  factory FavoriteTranslation.fromJson(Map<String, dynamic> json) {
    return FavoriteTranslation(
      profileType: ProfileType.values.firstWhere(
        (e) => e.name == json['profileType'],
        orElse: () => ProfileType.baby,
      ),
      phrase: json['phrase'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileType': profileType.name,
      'phrase': phrase,
      'date': date.toIso8601String(),
    };
  }
}