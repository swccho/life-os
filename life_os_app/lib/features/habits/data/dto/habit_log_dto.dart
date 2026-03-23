class HabitLogDto {
  const HabitLogDto({
    required this.id,
    required this.habitId,
    required this.loggedDate,
  });

  final String id;
  final String habitId;
  /// `Y-m-d`
  final String loggedDate;

  factory HabitLogDto.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final id = idRaw is int ? '$idRaw' : idRaw as String;
    final hid = json['habit_id'];
    final habitId = hid is int ? '$hid' : hid as String;
    final date = json['logged_date'] as String? ?? '';
    return HabitLogDto(id: id, habitId: habitId, loggedDate: date);
  }
}
