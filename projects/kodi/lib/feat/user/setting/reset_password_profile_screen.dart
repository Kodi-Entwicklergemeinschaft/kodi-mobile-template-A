import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/config/image.dart';
import 'package:kodi/utils/widgets/page_count_dotted_ui.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';

import '../../../../utils/routing/routes.dart';
import '../../../common_widget.dart';
import '../../../utils/app_pref_keys.dart';
import '../profile/controller/profile_controller.dart';
import '../../auth/reset_password/controller/reset_password_controller.dart';
import '../../auth/reset_password/controller/reset_password_state.dart';

class ResetPasswordProfileScreen extends ConsumerStatefulWidget {
  const ResetPasswordProfileScreen({super.key});

  @override
  ConsumerState<ResetPasswordProfileScreen> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends ConsumerState<ResetPasswordProfileScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    _emailController.text=ref.read(preferenceManagerProvider).getStringOrEmpty(AppPrefsKeys.email);
    super.initState();
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
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 70.iY,
        // title: CommonText(
        //   titleText: "reset_password".tr(context),
        //   textStyle: Theme.of(context).textTheme.headlineSmall,
        // ),
      ),
      bodyPadding: EdgeInsetsGeometry.all(20.iY),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(10.iY),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.iY,
            children: [
              SizedBox(
                width: double.infinity,
                child: CommonText(
                  textAlign: TextAlign.start,
                  titleText: "reset_password".tr(context).toUpperCase(),
                  textStyle: TextStyle(
                    fontSize: 20.iY,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CommonTextField(
                controller: _emailController,
                focusNode: _emailFocus,
                readOnly: true,
                fillColor: AppColors.textFieldLightColor,
                focusColor: Theme.of(context).extension<AppContainerColors>()!.normal,
                hintTextColor: Theme.of(context).extension<AppTextColors>()!.normal,
                labelTextColor: Theme.of(context).extension<AppTextColors>()!.normal,
                label: ('reset_password_email_label').tr(context),
              ),

              Consumer(
                builder: (_, ref, __) {
                  final resetPasswordState = ref.watch(
                    resetPasswordProvider,
                  );
                  return AppButton(
                    ('submit').tr(context),
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
            ],
          ),
        ),
      ),
    );
  }
}
