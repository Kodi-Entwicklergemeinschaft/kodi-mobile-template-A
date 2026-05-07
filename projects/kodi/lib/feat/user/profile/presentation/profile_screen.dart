import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/base_UI/presentation/base_ui_screen.dart';
import 'package:kodi/feat/user/profile/controller/profile_controller.dart';
import 'package:kodi/feat/user/profile/controller/profile_state.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:kodi/utils/enums/StateEnum.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';
import 'package:locale/app_localization.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  TextEditingController firstNameTEC = TextEditingController();
  TextEditingController lastNameTEC = TextEditingController();
  TextEditingController dobTEC = TextEditingController();

  TextEditingController streetTEC = TextEditingController();
  TextEditingController houseNumberTEC = TextEditingController();
  TextEditingController postalCodeTEC = TextEditingController();
  TextEditingController cityTEC = TextEditingController();

  TextEditingController vehicleFirstRegistrationTEC = TextEditingController();
  TextEditingController vehicleLicencePlateTEC = TextEditingController();

  @override
  void initState() {
    Future.microtask(() async {
      ref.read(profileProvider.notifier).getProfileData();
    });
    super.initState();
  }

  void _updateControllers(ProfileState state) {
    firstNameTEC.text = state.firstName;
    lastNameTEC.text = state.lastName;
  }

  @override
  Widget build(BuildContext context) {

    ref.listen(profileProvider, (previous, next) {
      if (previous != next) {
        if (next.status == StateEnum.success) {
          _updateControllers(next);
        }
        if (next.status == StateEnum.successSnackBar) {
          AppSnackBar.showSuccess(context, "Profile updated successfully");
        }
        if (next.status == StateEnum.error) {
          AppSnackBar.showError(context, next.errorMessage);
        }
      }
    });

    return BaseUI(
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 70.iY,
      ),
      body: SafeArea(
          child: _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final controller = ref.read(profileProvider.notifier);
    final state = ref.watch(profileProvider);
    final space = 25.iY;

    return state.status == StateEnum.loading ? Center(
      child: CircularProgressIndicator(),
    ): SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.iX),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonText(
              titleText: "my_profile_data".tr(context).toUpperCase(),
              textStyle: TextStyle(
                fontSize: 16.iY,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.iY),
            // if(state.salutationLabels.isNotEmpty)
            // _buildDropDown(
            //   context,
            //   hintText: "salutation".tr(context),
            //   value: state.salutation.isEmpty ? null : state.salutation,
            //   itemList: state.salutationLabels,
            //   onChange: (value) {
            //     controller.updateSalutation(value ?? '');
            //   },
            // ),

            SizedBox(height: space),
            _buildTextField(
              controller: firstNameTEC,
              hintText: "first_name".tr(context),
              onChange: (value) {
                controller.updateFirstName(value ?? '');
              },
            ),
            SizedBox(height: space),
            _buildTextField(
              controller: lastNameTEC,
              hintText: "last_name".tr(context),
              onChange: (value) {
                controller.updateLastName(value ?? '');
              },
            ),
            // SizedBox(height: space),
            // _buildDateOfBirth(context),
            // SizedBox(height: space),
            // _buildAddress(context),
            // SizedBox(height: space),
            // _buildMartialStatus(context),
            // SizedBox(height: space,),
            // _buildEmployment(context),
            // SizedBox(height: space),
            // _buildVehicle(context),
            SizedBox(height: space),
            AppButton(
              loading: state.status==StateEnum.loadingDialog,
              onPressed: () {
                CommonMethods.hiddenKeyboard(context);
                controller.updateProfileData();
              },
              "submit".tr(context),
              type: ButtonType.normal,
            )
          ],
        ),
      ),
    ) ;
  }

  _buildDateOfBirth(BuildContext context) {
    final controller = ref.read(profileProvider.notifier);
    final state = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonText(
          titleText: "date_of_birth".tr(context),
          textStyle: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10.iY),
        _buildTextField(
          controller: dobTEC,
          hintText: "select_date".tr(context),
          onChange: (value) {},
          prefixIcon: CommonIcon( icon:
            Icons.calendar_month_outlined,
            label: 'common_icon_label'.tr(context).replaceAll('{itemName}', "select_date".tr(context)),
            color: AppColors.dark,
          ),
          readOnly: true,
          suffixIcon: CommonIcon(
              icon:Icons.keyboard_arrow_down,
              label: 'common_icon_label'.tr(context).replaceAll('{itemName}', "select_date".tr(context)),
              color: AppColors.dark),
        ),
      ],
    );
  }

  _buildAddress(BuildContext context) {
    final controller = ref.read(profileProvider.notifier);
    final state = ref.watch(profileProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          titleText: "address".tr(context),
          textStyle: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10.iY),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .55,
              child: _buildTextField(
                controller: streetTEC,
                hintText: "street".tr(context),
                onChange: (value) {},
              ),
            ),
            SizedBox(width: 16.iX),
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: _buildTextField(
                controller: houseNumberTEC,
                hintText: "house_number".tr(context),
                onChange: (value) {},
              ),
            ),
          ],
        ),
        SizedBox(height: 10.iY),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * .15,
              child: _buildTextField(
                controller: postalCodeTEC,
                hintText: "zip_code".tr(context),
                onChange: (value) {},
              ),
            ),
            SizedBox(width: 16.iX),
            SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: _buildTextField(
                controller: cityTEC,
                hintText: "city".tr(context),
                onChange: (value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildMartialStatus(BuildContext context) {
    final controller = ref.read(profileProvider.notifier);
    final state = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          titleText: "marital_status".tr(context),
          textStyle: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        _buildDropDown(
          context,
          hintText: "marital_status_select".tr(context),
          value: '',
          itemList: [],
          onChange: (value) {},
        ),
      ],
    );
  }

  _buildEmployment(BuildContext context) {
    final controller = ref.read(profileProvider.notifier);
    final state = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText(
          titleText: "employment".tr(context),
          textStyle: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        _buildDropDown(
          context,
          hintText: "employment_select".tr(context),
          value: '',
          itemList: [],
          onChange: (value) {},
        ),
      ],
    );
  }

  _buildVehicle(BuildContext context) {
    final controller = ref.read(profileProvider.notifier);
    final state = ref.watch(profileProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CommonText(
          titleText: "vehicle".tr(context),
          textStyle: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 12.iY),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                checkboxTheme: const CheckboxThemeData(
                  // visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              child: Checkbox(
                value: state.isIOwnVehicle,
                onChanged: (value) {
                  controller.updateIsIOwnVehicleValue(value ?? false);
                },
                // fillColor: MaterialStateProperty.all(
                //   AppColors.textFieldLightColor,
                // ),
                // side: BorderSide(color: Colors.transparent),
                // checkColor: AppColors.dark,
              ),
            ),
            SizedBox(width: 8.iX),
            Expanded(
              child: CommonText(
                textAlign: TextAlign.start,
                titleText: "vehicle_owns".tr(context),
                textStyle: TextStyle( fontSize: 14),
              ),
            ),
          ],
        ),
        // SizedBox(height: 12.iY),
        //
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     SizedBox(
        //       width: MediaQuery.of(context).size.width * .42,
        //       child: _buildTextField(
        //         controller: vehicleFirstRegistrationTEC,
        //         hintText: "vehicle_first_registration".tr(context),
        //         onChange: (value) {},
        //       ),
        //     ),
        //     SizedBox(width: 20.iX),
        //     SizedBox(
        //       width: MediaQuery.of(context).size.width * .42,
        //       child: _buildTextField(
        //         controller: vehicleLicencePlateTEC,
        //         hintText: "vehicle_license_plate".tr(context),
        //         onChange: (value) {},
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  _buildDropDown(
    BuildContext context, {
    required String hintText,
    required String? value,
    required List<String> itemList,
    required Function(String?) onChange,
  }) {
    return CustomUnderlinedDropdown(
      hintText: hintText,
      // hintColor: AppColors.black.withOpacity(0.5),
      value: value,
      items: itemList,
      onChanged: onChange,
      suffixIcon: CommonIcon(
          icon:Icons.keyboard_arrow_down,
          label: 'common_icon_label'.tr(context).replaceAll('{itemName}', "down".tr(context)),
          color:Theme.of(context).extension<AppContainerColors>()!.normal ),
    );
  }

  _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required Function(String?) onChange,
    bool readOnly = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return CommonTextField(
      controller: controller,
      label: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      readOnly: readOnly,
      fillColor: AppColors.textFieldLightColor,
      focusColor: Theme.of(context).extension<AppContainerColors>()!.normal,
      hintTextColor: Theme.of(context).extension<AppTextColors>()!.normal,
      labelTextColor: Theme.of(context).extension<AppTextColors>()!.normal,
      onChanged: onChange,
    );
  }
}
