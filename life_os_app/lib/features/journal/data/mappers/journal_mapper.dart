import '../../../mood/data/models/mood_level.dart';
import '../dto/journal_entry_dto.dart';
import '../models/journal_entry_model.dart';

JournalEntryModel journalDtoToModel(
  JournalEntryDto dto, {
  MoodLevel? mood,
  String? tag,
}) {
  final entryDate = _parseYmd(dto.entryDate) ?? DateTime.now();
  final created = dto.createdAt ?? entryDate;
  final updated = dto.updatedAt ?? created;
  final rawTitle = (dto.title ?? '').trim();
  return JournalEntryModel(
    id: dto.id,
    title: rawTitle.isEmpty ? 'Untitled' : rawTitle,
    content: dto.content,
    mood: mood,
    tag: tag,
    entryDate: DateTime(entryDate.year, entryDate.month, entryDate.day),
    createdAt: created,
    updatedAt: updated,
  );
}

DateTime? _parseYmd(String raw) {
  if (raw.isEmpty) return null;
  final p = raw.split('-');
  if (p.length != 3) return DateTime.tryParse(raw);
  final y = int.tryParse(p[0]);
  final m = int.tryParse(p[1]);
  final d = int.tryParse(p[2]);
  if (y == null || m == null || d == null) return null;
  return DateTime(y, m, d);
}

String journalEntryDateToApi(DateTime d) {
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '${d.year}-$m-$day';
}
