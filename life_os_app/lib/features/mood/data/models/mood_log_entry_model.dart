import 'package:equatable/equatable.dart';

import 'mood_level.dart';

class MoodLogEntryModel extends Equatable {
  const MoodLogEntryModel({
    required this.id,
    required this.mood,
    required this.loggedAt,
    this.note,
  });

  final String id;
  final MoodLevel mood;
  final String? note;
  final DateTime loggedAt;

  MoodLogEntryModel copyWith({
    String? id,
    MoodLevel? mood,
    String? note,
    DateTime? loggedAt,
    bool clearNote = false,
  }) {
    return MoodLogEntryModel(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      note: clearNote ? null : (note ?? this.note),
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  List<Object?> get props => [id, mood, note, loggedAt];
}
