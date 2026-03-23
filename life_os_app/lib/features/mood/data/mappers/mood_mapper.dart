import '../dto/mood_entry_dto.dart';
import '../models/mood_level.dart';
import '../models/mood_log_entry_model.dart';

MoodLogEntryModel moodDtoToModel(MoodEntryDto dto) {
  final logged = dto.createdAt ?? _fromYmd(dto.entryDate) ?? DateTime.now();
  return MoodLogEntryModel(
    id: dto.id,
    mood: moodScoreToLevel(dto.moodScore),
    note: dto.notes,
    loggedAt: logged,
  );
}

MoodLevel moodScoreToLevel(int score) {
  switch (score.clamp(1, 5)) {
    case 5:
      return MoodLevel.great;
    case 4:
      return MoodLevel.good;
    case 3:
      return MoodLevel.okay;
    case 2:
      return MoodLevel.low;
    default:
      return MoodLevel.stressed;
  }
}

int moodLevelToScore(MoodLevel m) {
  switch (m) {
    case MoodLevel.great:
      return 5;
    case MoodLevel.good:
      return 4;
    case MoodLevel.okay:
      return 3;
    case MoodLevel.low:
      return 2;
    case MoodLevel.stressed:
      return 1;
  }
}

DateTime? _fromYmd(String raw) {
  if (raw.isEmpty) return null;
  final p = raw.split('-');
  if (p.length != 3) return DateTime.tryParse(raw);
  final y = int.tryParse(p[0]);
  final m = int.tryParse(p[1]);
  final d = int.tryParse(p[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d, 12);
}

String moodEntryDateToApi(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}
