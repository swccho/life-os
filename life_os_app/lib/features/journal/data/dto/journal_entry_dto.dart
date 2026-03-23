class JournalEntryDto {
  const JournalEntryDto({
    required this.id,
    this.title,
    required this.content,
    required this.entryDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? title;
  final String content;
  /// `Y-m-d`
  final String entryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory JournalEntryDto.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is int ? '$idRaw' : idRaw as String;
    return JournalEntryDto(
      id: id,
      title: json['title'] as String?,
      content: json['content'] as String? ?? '',
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
