import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/tokens/app_colors.dart';
import '../../../../app/theme/tokens/app_radii.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../shared/extensions/context_snackbars.dart';
import '../../data/models/task_model.dart';
import '../providers/tasks_notifier.dart';
import '../widgets/add_task_form_fields.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _note = TextEditingController();
  DateTime? _due;
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.personal;

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDue() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_due ?? now),
    );
    if (time == null) return;
    if (!mounted) return;
    setState(() {
      _due = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final err = await ref.read(tasksNotifierProvider.notifier).createTask(
          title: _title.text.trim(),
          description: _note.text.trim(),
          priority: _priority,
          category: _category,
          dueDate: _due,
        );
    if (!mounted) return;
    if (err != null) {
      context.showAppSnackBar(err, isError: true);
      return;
    }
    context.showAppSnackBar('Task created');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('New task'),
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
            AddTaskFormFields(
              titleController: _title,
              noteController: _note,
              selectedDue: _due,
              onPickDue: _pickDue,
              onClearDue: () => setState(() => _due = null),
              priority: _priority,
              onPriorityChanged: (p) => setState(() => _priority = p),
              category: _category,
              onCategoryChanged: (c) => setState(() => _category = c),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.neonPrimary,
                foregroundColor: AppColors.onNeon,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
              ),
              child: const Text('Save task'),
            ),
          ],
        ),
      ),
    );
  }
}
