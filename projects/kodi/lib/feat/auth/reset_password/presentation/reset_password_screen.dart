import 'package:common_components/common_components.dart';
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

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPassword> with TickerProviderStateMixin {
  bool _animate = false;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
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
    _emailFocus.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref
          .read(resetPasswordProvider.notifier)
          .resetPassword(_emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(resetPasswordProvider, (previous, next) {
      if (previous != next) {
        if (next is ResetPasswordSuccess) {
          AppSnackBar.showSuccess(
            context,
            next.message ?? "reset_link_send".tr(context),
          );
          context.pop();
        } else if (next is ResetPasswordError) {
          AppSnackBar.showError(context, next.error);
        }
      }
    });
    return BaseUI(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.dark,
      appBar: CommonAppBar(
        showBackButton: true,
        backgroundColor: AppColors.dark,
        backButtonColor: AppColors.secondary,
      ),
      bodyPadding: EdgeInsets.zero,
      body: Stack(
        children: [
          buildWave(animate: _animate, imagePath: Images.wave5Svg),
          buildWave(
            animate: _animate,
            imagePath: Images.wave6Svg,
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
                slideForward: false,
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10.iY,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.iX),
                        child: Semantics(
                          label: 'kodi_app_logo_label'.tr(context),
                          child: onboardingKodiLogo(),
                        ),
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
                              text: ('password_reset_title').tr(context),
                              semanticsLabel: ('password_reset_title').tr(context),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.iY),

                      SlideTransition(
                        position: _slideAnimation,
                        child: CommonTextField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          textInputAction:
                          TextInputAction.done,
                          onSubmitted: (_) => _submit(),
                          label: ('reset_password_email_label').tr(context),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return ('login_email_validation_empty').tr(context);
                            }
                            if (!RegExp(r'^.+@.+\..+$').hasMatch(v)) {
                              return ('login_email_validation_invalid').tr(context);
                            }
                            return null;
                          },
                          suffixIcon: (_emailController.text.isNotEmpty)
                              ? CommonIcon(
                            icon: Icons.cancel,
                            color: AppColors.secondary,
                            label:
                            'clear_email_label'
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppButton(
                          ('remember_password_login_again').tr(context),
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
                            loading: resetPasswordState is ResetPasswordLoading,
                            disabled: (_emailController.text.isNotEmpty)
                                ? false
                                : true,
                            type: ButtonType.normal,
                            size: ButtonSize.large,
                            onPressed: _submit,
                          );
                        },
                      ),
                      PageCountDottedUI(totalPage: 6, currentPage: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
