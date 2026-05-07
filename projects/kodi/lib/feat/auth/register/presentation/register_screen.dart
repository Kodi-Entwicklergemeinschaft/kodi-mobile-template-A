import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/register/controller/register_controller.dart';
import 'package:kodi/feat/auth/register/controller/register_state.dart';
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

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterRegisterState();
}

class _RegisterRegisterState extends ConsumerState<Register>
    with TickerProviderStateMixin {
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

  _onRegister() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      ref
          .read(registerProvider.notifier)
          .register(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(registerProvider, (previous, next) {
      if (next is RegisterSuccess) {
        AppSnackBar.showSuccess(context, next.message);
        context.pushReplacement(ScreenPaths.login);
      } else if (next is RegisterError) {
        AppSnackBar.showError(context, next.error);
      }
    });
    return BaseUI(
      backgroundColor: AppColors.dark,
      resizeToAvoidBottomInset: false,
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
            child: onboardingBuildings(
              animate: _animate,
              initialStart: 0.07,
              finalStart: 0.45,
              slideForward: false,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20.iY,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.iX),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 10.iY,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.iY),
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
                                    text: ('registration_title').tr(context),
                                    semanticsLabel: ('registration_title').tr(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.iY),
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
                                    text: ('registration_subtitle').tr(context),
                                    semanticsLabel: ('registration_subtitle').tr(
                                      context,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SlideTransition(
                              position: _slideAnimation,
                              child: CommonTextField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_passwordFocus);
                                },
                                label: ('register_email_label').tr(context),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return ('register_email_validation_empty').tr(
                                      context,
                                    );
                                  }
                                  if (!RegExp(r'^.+@.+\..+$').hasMatch(v)) {
                                    return ('register_email_validation_invalid')
                                        .tr(context);
                                  }
                                  return null;
                                },
                                suffixIcon: (_emailController.text.isNotEmpty)
                                    ? CommonIcon(
                                        icon: Icons.cancel,
                                        color: AppColors.secondary,
                                        label: 'clear_email_label'.tr(
                                          context,
                                        ),
                                        onPressed: () {
                                          _emailController.text = '';
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
                                onSubmitted: (_) => _onRegister(),
                                label: ('register_password_label').tr(context),
                                obscureText: !_isPasswordVisible,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return ('register_password_validation_empty')
                                        .tr(context);
                                  }
                                  return null;
                                },
                                suffixIcon: CommonIcon(
                                  color: AppColors.secondary,
                                  label: _isPasswordVisible
                                      ? 'hide_password_label'.tr(context)
                                      : 'show_password_label'.tr(context),
                                  icon: _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: AppButton(
                                ('login_already_registered_login').tr(context),
                                type: ButtonType.text,
                                onPressed: () {
                                  context.pushReplacement(ScreenPaths.login);
                                },
                              ),
                            ),
                            Consumer(
                              builder: (_, ref, __) {
                                final registerState = ref.watch(registerProvider);
                                return AppButton(
                                  ('next_button').tr(context),
                                  disabled:
                                      (_emailController.text.isNotEmpty &&
                                          _passwordController.text.isNotEmpty)
                                      ? false
                                      : true,
                                  loading: registerState is RegisterLoading,
                                  type: ButtonType.normal,
                                  size: ButtonSize.large,
                                  onPressed: () => _onRegister(),
                                );
                              },
                            ),
                            PageCountDottedUI(totalPage: 6, currentPage: 2),
                          ],
                        ),
                      ),
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
