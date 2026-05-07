import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/feat/auth/login/controller/login_state.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/app_pref_keys.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/widgets/page_count_dotted_ui.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../../../utils/routing/routes.dart';
import '../../../../common_widget.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _RegisterSignupState();
}

class _RegisterSignupState extends ConsumerState<Login> with TickerProviderStateMixin{
  bool _animate = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animate = true);
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 2), // starts offscreen at bottom
      end: Offset(0, 0), // ends at normal position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(loginProvider.notifier).login(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previous, next) {
      if (previous != next) {
        if (next is LoginSuccess) {
          if (!ref
              .read(preferenceManagerProvider)
              .getBool(AppPrefsKeys.isTermsAndConditionAccepted)) {
            context.go(ScreenPaths.termsConditions);
          } else {
            context.go(ScreenPaths.home);
          }
        } else if (next is LoginError) {
          AppSnackBar.showError(
            context,
            (next.error.isNotEmpty)
                ? next.error
                : 'general_err_message'.tr(context),
          );
        }
      }
    });
    return BaseUI(
      backgroundColor: AppColors.dark,
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(
        showBackButton: true,
        backButtonColor: AppColors.secondary,
        backgroundColor: AppColors.dark,
      ),
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          buildWave(animate: _animate, imagePath: Images.wave6Svg),
          buildWave(
            animate: _animate,
            imagePath: Images.wave5Svg,
            reverse: true, // 👈 this flips the animation direction
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Semantics(
              label: 'onboarding_buildings_illustration'.tr(context),
              child: onboardingBuildings(
                animate: _animate,
                initialStart: 0.07,
                finalStart: 0.45,
              ),
            ),
          ),
          onboardingBottomInfo(),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.iX),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.manual,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20.iY,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.iX),
                      child: Semantics(
                        label: 'kodi_app_logo_label'.tr(context),
                        child: onboardingKodiLogo(),
                      ),
                    ),
                    Semantics(
                      header: true,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 32.iX,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: ('registration_title').tr(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 24.iX,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        children: [
                          TextSpan(
                            text: ('login_subtitle').tr(context),
                            semanticsLabel: ('login_subtitle').tr(
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        spacing: 12.iY,
                        children: [
                          SlideTransition(
                            position: _slideAnimation,
                            child: CommonTextField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus);
                              },
                              label: ('login_email_label').tr(
                                context,
                              ),
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return ('login_email_validation_empty')
                                      .tr(context);
                                }
                                if (!RegExp(
                                  r'^.+@.+\..+$',
                                ).hasMatch(v)) {
                                  return ('login_email_validation_invalid')
                                      .tr(context);
                                }
                                return null;
                              },
                              suffixIcon:
                              (_emailController
                                  .text
                                  .isNotEmpty)
                                  ? CommonIcon(
                                icon: Icons.cancel,
                                color: AppColors.secondary,
                                label: 'clear_email_label'
                                    .tr(context),
                                onPressed: () {
                                  _emailController.text =
                                  '';
                                  setState(() {});
                                },
                              )
                                  : null,
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                          SlideTransition(
                            position: _slideAnimation,
                            child: CommonTextField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _login(),
                              label: ('login_password_label').tr(
                                context,
                              ),
                              obscureText: !_isPasswordVisible,
                              autovalidateMode: AutovalidateMode
                                  .onUserInteraction,
                              validator: (v) {
                                if (v.isNullOrEmpty) {
                                  return ('login_password_validation_empty')
                                      .tr(context);
                                }
                                return null;
                              },
                              suffixIcon: CommonIcon(
                                color: AppColors.secondary,
                                label: _isPasswordVisible
                                    ? 'hide_password_label'
                                    .tr(context)
                                    : 'show_password_label'
                                    .tr(context),
                                icon: _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible =
                                    !_isPasswordVisible;
                                  });
                                },
                              ),
                              onChanged: (_) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: AppButton(
                            ('password_reset_title').tr(context),
                            type: ButtonType.text,
                            onPressed: () {
                              context.push(
                                ScreenPaths.forgotPassword,
                              );
                            },
                          ),
                        ),
                        Flexible(
                          child: AppButton(
                            ('login_no_account_register').tr(
                              context,
                            ),
                            type: ButtonType.text,
                            textAlign: TextAlign.end,
                            onPressed: () {
                              context.pushReplacement(
                                ScreenPaths.register,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Consumer(
                      builder: (_, ref, __) {
                        final loginState = ref.watch(
                          loginProvider,
                        );
                        return AppButton(
                          ('next_button').tr(context),
                          loading: loginState is LoginLoading,
                          disabled:
                          (_emailController
                              .text
                              .isNotEmpty &&
                              _passwordController
                                  .text
                                  .isNotEmpty)
                              ? false
                              : true,
                          type: ButtonType.normal,
                          onPressed: _login,
                        );
                      },
                    ),
                    PageCountDottedUI(
                      totalPage: 6,
                      currentPage: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
