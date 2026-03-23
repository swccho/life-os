class HabitDto {
  const HabitDto({
    required this.id,
    required this.name,
    this.description,
    required this.frequencyType,
    required this.targetCount,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final String frequencyType;
  final int targetCount;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory HabitDto.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is int ? '$idRaw' : idRaw as String;
    final tc = json['target_count'];
    return HabitDto(
      id: id,
      name: json['name'] as String,
      description: json['description'] as String?,
      frequencyType: json['frequency_type'] as String? ?? 'daily',
      targetCount: tc is int ? tc : int.tryParse('$tc') ?? 1,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is String && value.isNotEmpty) return DateTime.tryParse(value);
    return null;
  }
}
