import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_input_styles.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_screen_background.dart';
import '../providers/auth_notifier.dart';
import '../utils/auth_validators.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenStateImpl();
}

class _RegisterScreenStateImpl extends ConsumerState<RegisterScreen> {
  static const _entranceDuration = Duration(milliseconds: 380);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).clearError();
    });
  }

  @override
  void dispose() {
    ref.read(authNotifierProvider.notifier).clearError();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext formContext) async {
    if (!Form.of(formContext).validate()) return;
    FocusScope.of(context).unfocus();
    await ref.read(authNotifierProvider.notifier).register(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final scheme = Theme.of(context).colorScheme;
    final iconMuted = lifeMutedIconColor(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScreenBackground(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: auth.isBusy ? null : () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    style: IconButton.styleFrom(
                      foregroundColor: textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                Text(
                  'Create account',
                  style: textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Start your LifeOS journey',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: _entranceDuration,
                  curve: Curves.easeOutCubic,
                  builder: (context, t, child) {
                    return Opacity(
                      opacity: t.clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, 12 * (1 - t)),
                        child: child,
                      ),
                    );
                  },
                  child: AppGlassCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    elevated: true,
                    child: Form(
                      child: Builder(
                        builder: (formContext) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                          if (auth.errorMessage != null) ...[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: scheme.errorContainer.withValues(alpha: 0.55),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: scheme.error.withValues(alpha: 0.35),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.sm),
                                child: Text(
                                  auth.errorMessage!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: scheme.onErrorContainer,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            style: textTheme.bodyLarge,
                            decoration: lifeInputDecoration(
                              context,
                              label: 'Name',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: 22,
                                color: iconMuted,
                              ),
                            ),
                            validator: AuthValidators.name,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            style: textTheme.bodyLarge,
                            decoration: lifeInputDecoration(
                              context,
                              label: 'Email',
                              prefixIcon: Icon(
                                Icons.mail_outlined,
                                size: 22,
                                color: iconMuted,
                              ),
                            ),
                            validator: AuthValidators.email,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            style: textTheme.bodyLarge,
                            decoration: lifeInputDecoration(
                              context,
                              label: 'Password',
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                size: 22,
                                color: iconMuted,
                              ),
                              suffixIcon: IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: auth.isBusy
                                    ? null
                                    : () => setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        }),
                                tooltip: _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                style: IconButton.styleFrom(
                                  foregroundColor: iconMuted,
                                  disabledForegroundColor:
                                      iconMuted.withValues(alpha: 0.35),
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            validator: AuthValidators.password,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(formContext),
                            style: textTheme.bodyLarge,
                            decoration: lifeInputDecoration(
                              context,
                              label: 'Confirm password',
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                size: 22,
                                color: iconMuted,
                              ),
                              suffixIcon: IconButton(
                                visualDensity: VisualDensity.compact,
                                onPressed: auth.isBusy
                                    ? null
                                    : () => setState(() {
                                          _obscureConfirm = !_obscureConfirm;
                                        }),
                                tooltip: _obscureConfirm
                                    ? 'Show password'
                                    : 'Hide password',
                                style: IconButton.styleFrom(
                                  foregroundColor: iconMuted,
                                  disabledForegroundColor:
                                      iconMuted.withValues(alpha: 0.35),
                                ),
                                icon: Icon(
                                  _obscureConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            validator: (v) => AuthValidators.confirmPassword(
                              v,
                              _passwordController.text,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppPrimaryButton(
                            label: 'Register',
                            isLoading: auth.isBusy,
                            onPressed: () => _submit(formContext),
                          ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        'Already have an account?',
                        style: textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: auth.isBusy ? null : () => context.push('/login'),
                        child: Text(
                          'Log in',
                          style: textTheme.titleSmall?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
