import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../data/models/habit_model.dart';
import '../providers/habits_notifier.dart';
import '../widgets/add_habit_form_fields.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _target = TextEditingController();
  HabitCategory _category = HabitCategory.health;
  HabitFrequency _frequency = HabitFrequency.daily;
  HabitPartOfDay _partOfDay = HabitPartOfDay.morning;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _target.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final now = DateTime.now();
    final err = await ref.read(habitsNotifierProvider.notifier).createHabit(
          title: _title.text.trim(),
          description: _description.text.trim(),
          category: _category,
          frequency: _frequency,
          partOfDay: _partOfDay,
          targetLabel: _target.text.trim().isEmpty ? null : _target.text.trim(),
          weeklyDueWeekday: _frequency == HabitFrequency.weekly
              ? now.weekday
              : null,
        );
    if (!mounted) return;
    if (err != null) {
      context.showAppSnackBar(err, isError: true);
      return;
    }
    context.showAppSnackBar('Habit created');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('New habit'),
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
            AddHabitFormFields(
              titleController: _title,
              descriptionController: _description,
              targetController: _target,
              category: _category,
              onCategoryChanged: (c) => setState(() => _category = c),
              frequency: _frequency,
              onFrequencyChanged: (f) => setState(() => _frequency = f),
              partOfDay: _partOfDay,
              onPartOfDayChanged: (p) => setState(() => _partOfDay = p),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accentCyan,
                foregroundColor: AppColors.onNeon,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
              ),
              child: const Text('Save habit'),
            ),
          ],
        ),
      ),
    );
  }
}
