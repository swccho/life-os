import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../../mood/data/models/mood_level.dart';
import '../../../mood/presentation/widgets/mood_selector.dart';
import '../providers/journal_notifier.dart';

class AddJournalEntryScreen extends ConsumerStatefulWidget {
  const AddJournalEntryScreen({super.key});

  @override
  ConsumerState<AddJournalEntryScreen> createState() =>
      _AddJournalEntryScreenState();
}

class _AddJournalEntryScreenState extends ConsumerState<AddJournalEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  final _tag = TextEditingController();
  MoodLevel? _mood;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _tag.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final tag = _tag.text.trim();
    final err = await ref.read(journalNotifierProvider.notifier).createEntry(
          title: _title.text.trim(),
          content: _body.text.trim(),
          entryDate: day,
          mood: _mood,
          tag: tag.isEmpty ? null : tag,
        );
    if (!mounted) return;
    if (err != null) {
      context.showAppSnackBar(err, isError: true);
      return;
    }
    context.showAppSnackBar('Journal entry saved');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final createdLabel = DateFormat.yMMMEd().add_jm().format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('New entry'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            AppGlassCard(
              elevated: true,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    createdLabel,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppGlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _title,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Give this moment a name',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Add a short title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _body,
                    minLines: 6,
                    maxLines: 14,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Write freely',
                      hintText: 'What happened, what you felt, what you learned…',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Write at least a few words';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppGlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mood (optional)',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  MoodSelector(
                    selected: _mood,
                    onSelected: (m) => setState(() => _mood = m),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppGlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: TextFormField(
                controller: _tag,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Tag (optional)',
                  hintText: 'Gratitude, Work, Health…',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor:
                    AppColors.accentPurple.withValues(alpha: 0.88),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
              ),
              child: const Text('Save entry'),
            ),
          ],
        ),
      ),
    );
  }
}
