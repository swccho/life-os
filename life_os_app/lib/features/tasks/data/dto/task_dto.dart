class TaskDto {
  const TaskDto({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.priority,
    this.dueDate,
    this.completedAt,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String? description;
  final String status;
  final String? priority;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is int ? '$idRaw' : idRaw as String;
    return TaskDto(
      id: id,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'pending',
      priority: json['priority'] as String?,
      dueDate: _parseDate(json['due_date']),
      completedAt: _parseDate(json['completed_at']),
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
