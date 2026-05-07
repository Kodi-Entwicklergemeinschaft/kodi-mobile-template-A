import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/widgets/page_count_dotted_ui.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import '../../../../../utils/routing/routes.dart';
import '../../../../common_widget.dart';
import '../controller/reset_password_controller.dart';
import '../controller/reset_password_state.dart';

/// Not using change password screen for mobile devices.
class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  bool _animate = false;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _animate = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(resetPasswordProvider, (previous, next) {
    //   if (previous != next) {
    //     if (next is ChangePasswordSuccess) {
    //       context.pushReplacement(ScreenPaths.login);
    //     } else if (next is ChangePasswordError) {
    //       AppSnackBar.showError(context, next.error);
    //     }
    //   }
    // });
    return BaseUI(
      resizeToAvoidBottomInset: false,
      appBar: CommonAppBar(showBackButton: true),
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
            child: onboardingBuildings(
              animate: _animate,
              initialStart: 0.07,
              finalStart: 0.45,
            ),
          ),
          onboardingBottomInfo(),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.iX),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10.iY,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.iX),
                    child: onboardingKodiLogo(),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 32.iX,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: ('password_change_title').tr(context),
                          semanticsLabel: ('password_change_title').tr(context),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.iY),
                  Expanded(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.manual,
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 700),
                                curve: Curves.easeOutCubic,
                                left: 0,
                                right: 0,
                                // start at baseBottom, animate to baseBottom + moveDistance
                                bottom: _animate ? 140.iY : 0,
                                child: Padding(
                                  padding: EdgeInsets.all(16.iX),
                                  child: MoveUpWithFiller(
                                    animate: _animate,
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        spacing: 12.iY,
                                        children: [
                                          CommonTextField(
                                            controller: _passwordController,
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
                                            suffixIcon: IconButton(
                                              icon: CommonIcon( icon:
                                                _isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: AppColors.secondary,
                                                label: _isPasswordVisible
                                                    ? 'hide_password_label'
                                                    .tr(context)
                                                    : 'show_password_label'
                                                    .tr(context),
                                              ),
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
                                          CommonTextField(
                                            controller:
                                                _confirmPasswordController,
                                            label: ('confirm_password').tr(
                                              context,
                                            ),
                                            obscureText:
                                                !_isConfirmPasswordVisible,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (v) {
                                              if (v.isNullOrEmpty) {
                                                return ('login_password_validation_empty')
                                                    .tr(context);
                                              }
                                              return null;
                                            },
                                            suffixIcon: IconButton(
                                              icon: CommonIcon( icon:
                                                _isConfirmPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: AppColors.secondary,
                                                label: _isPasswordVisible
                                                    ? 'hide_password_label'
                                                    .tr(context)
                                                    : 'show_password_label'
                                                    .tr(context),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _isConfirmPasswordVisible =
                                                      !_isConfirmPasswordVisible;
                                                });
                                              },
                                            ),
                                            onChanged: (_) {
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 200.iY),
                                child: Column(
                                  spacing: 10.iY,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: AppButton(
                                        ('remember_password_login_again').tr(
                                          context,
                                        ),
                                        type: ButtonType.text,
                                        onPressed: () {
                                          context.push(ScreenPaths.login);
                                        },
                                      ),
                                    ),
                                    Consumer(
                                      builder: (_, ref, __) {
                                        final resetPasswordState = ref.watch(
                                          resetPasswordProvider,
                                        );
                                        return AppButton(
                                          ('next_button').tr(context),
                                          loading:
                                              resetPasswordState
                                                  is ResetPasswordLoading,
                                          disabled:
                                              (_passwordController
                                                      .text
                                                      .isNotEmpty &&
                                                  _confirmPasswordController
                                                      .text
                                                      .isNotEmpty)
                                              ? false
                                              : true,
                                          type: ButtonType.normal,
                                          size: ButtonSize.large,
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              FocusScope.of(context).unfocus();
                                              ref
                                                  .read(
                                                    resetPasswordProvider
                                                        .notifier,
                                                  )
                                                  .confirmPassword(
                                                    _passwordController.text,
                                                  );
                                            }
                                          },
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
