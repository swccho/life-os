import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_input_styles.dart';
import '../../../../app/theme/tokens/app_spacing.dart';
import '../../../../core/widgets/app_glass_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_screen_background.dart';
import '../widgets/auth_brand_logo.dart';
import '../providers/auth_notifier.dart';
import '../utils/auth_validators.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenStateImpl();
}

class _LoginScreenStateImpl extends ConsumerState<LoginScreen> {
  static const _entranceDuration = Duration(milliseconds: 380);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(BuildContext formContext) async {
    if (!Form.of(formContext).validate()) return;
    FocusScope.of(context).unfocus();
    await ref
        .read(authNotifierProvider.notifier)
        .login(_emailController.text.trim(), _passwordController.text);
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              const scrollPadding = EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              );
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: scrollPadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - scrollPadding.vertical,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AuthBrandLogo(),
                      Text('Welcome back', style: textTheme.displaySmall),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Sign in to continue your journey',
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
                          child: Form(
                            child: Builder(
                              builder: (formContext) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (auth.errorMessage != null) ...[
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: scheme.errorContainer
                                              .withValues(alpha: 0.55),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: scheme.error.withValues(
                                              alpha: 0.35,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                            AppSpacing.sm,
                                          ),
                                          child: Text(
                                            auth.errorMessage!,
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                  color:
                                                      scheme.onErrorContainer,
                                                ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: AppSpacing.md),
                                    ],
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
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) =>
                                          _submit(formContext),
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
                                                  _obscurePassword =
                                                      !_obscurePassword;
                                                }),
                                          tooltip: _obscurePassword
                                              ? 'Show password'
                                              : 'Hide password',
                                          style: IconButton.styleFrom(
                                            foregroundColor: iconMuted,
                                            disabledForegroundColor: iconMuted
                                                .withValues(alpha: 0.35),
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
                                    const SizedBox(height: AppSpacing.lg),
                                    AppPrimaryButton(
                                      label: 'Log in',
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
                              "Don't have an account?",
                              style: textTheme.bodyMedium,
                            ),
                            GestureDetector(
                              onTap: auth.isBusy
                                  ? null
                                  : () => context.push('/register'),
                              child: Text(
                                'Create one',
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
              );
            },
          ),
        ),
      ),
    );
  }
}
