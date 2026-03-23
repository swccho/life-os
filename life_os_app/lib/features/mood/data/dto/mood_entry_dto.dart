class MoodEntryDto {
  const MoodEntryDto({
    required this.id,
    required this.moodScore,
    this.moodLabel,
    this.notes,
    required this.entryDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final int moodScore;
  final String? moodLabel;
  final String? notes;
  final String entryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MoodEntryDto.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is int ? '$idRaw' : idRaw as String;
    final scoreRaw = json['mood_score'];
    final score = scoreRaw is int ? scoreRaw : int.tryParse('$scoreRaw') ?? 3;
    return MoodEntryDto(
      id: id,
      moodScore: score,
      moodLabel: json['mood_label'] as String?,
      notes: json['notes'] as String?,
      entryDate: json['entry_date'] as String? ?? '',
      createdAt: _parse(json['created_at']),
      updatedAt: _parse(json['updated_at']),
    );
  }

  static DateTime? _parse(Object? v) {
    if (v is String && v.isNotEmpty) return DateTime.tryParse(v);
    return null;
  }
}
