import 'package:equatable/equatable.dart';

import '../../../mood/data/models/mood_level.dart';

class JournalEntryModel extends Equatable {
  const JournalEntryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.entryDate,
    this.mood,
    this.tag,
  });

  final String id;
  final String title;
  final String content;
  final MoodLevel? mood;
  final String? tag;
  /// Calendar day for this entry (API `entry_date`).
  final DateTime entryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get previewSnippet {
    final t = content.trim();
    if (t.isEmpty) return '';
    const max = 120;
    if (t.length <= max) return t;
    return '${t.substring(0, max).trim()}…';
  }

  JournalEntryModel copyWith({
    String? id,
    String? title,
    String? content,
    MoodLevel? mood,
    String? tag,
    DateTime? entryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearMood = false,
    bool clearTag = false,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: clearMood ? null : (mood ?? this.mood),
      tag: clearTag ? null : (tag ?? this.tag),
      entryDate: entryDate ?? this.entryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, content, mood, tag, entryDate, createdAt, updatedAt];
}
