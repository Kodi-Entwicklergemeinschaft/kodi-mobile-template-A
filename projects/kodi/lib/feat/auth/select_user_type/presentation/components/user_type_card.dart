import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/select_user_type/controller/select_user_type_controller.dart';
import 'package:kodi/feat/auth/select_user_type/controller/select_user_type_state.dart';
import 'package:kodi/feat/auth/select_user_type/presentation/components/select_user_type_ref_logic.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

class UserTypeCard extends StatelessWidget {
  final String text;
  final int value;
  final String imagePath;
  final WidgetRef ref;
  final String semanticsLabel;

  const UserTypeCard({
    super.key,
    required this.text,
    required this.value,
    required this.imagePath,
    required this.ref,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final selected = userType(ref)?.toInt;

    return GestureDetector(
      onTap: () => ref.read(selectUserTypeProvider.notifier).selectUserType(value),
      child: Container(
        width: 200.iX,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: selected == value
              ? Border.all(color: AppColors.primary, width: 3)
              : null,
          borderRadius: BorderRadius.circular(12.iX),
        ),
        child: Column(
          spacing: 10.iY,
          children: [
            CommonImage(imagePath: imagePath, width: 120.iX, height: 120.iY,label: semanticsLabel,),
            Center(
              child: CommonText(
                titleText: text,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  fontSize: 16.iX,
                ),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  onSurfaceVariant: Colors.grey,
                ),
              ),
              child: Radio<int>(
                value: value,
                groupValue: selected,
                onChanged: (val) =>
                    ref.read(selectUserTypeProvider.notifier).selectUserType(val!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
