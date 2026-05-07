import 'package:kodi/feat/user/profile/data/model/response_model/get_salutation_response_model.dart';
import 'package:kodi/utils/enums/StateEnum.dart';

class ProfileState {
  final String title;
  final String firstName;
  final String lastName;
  final String selectedDateOfBirth;
  final String selectedStreet;
  final String selectedZipCode;
  final String selectedHouse;
  final String selectedCity;
  final String selectedMartialStatus;
  final String selectedEmployment;
  final bool isIOwnVehicle;
  final StateEnum status;
  final String errorMessage;
  final String successMessage;
  final String salutation;
  final List<SalutationItem> salutationsList;
  final List<String> salutationLabels;

  const ProfileState({
    this.title = '',
    this.firstName = '',
    this.lastName = '',
    this.selectedDateOfBirth = '',
    this.selectedStreet = '',
    this.selectedZipCode = '',
    this.selectedHouse = '',
    this.selectedCity = '',
    this.selectedMartialStatus = '',
    this.selectedEmployment = '',
    this.isIOwnVehicle = false,
    this.status = StateEnum.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.salutation = '',
    this.salutationsList = const <SalutationItem>[],
    this.salutationLabels = const <String>[],
  });

  ProfileState copyWith({
    String? title,
    String? firstName,
    String? lastName,
    String? selectedDateOfBirth,
    String? selectedStreet,
    String? selectedZipCode,
    String? selectedHouse,
    String? selectedCity,
    String? selectedMartialStatus,
    String? selectedEmployment,
    bool? isIOwnVehicle,
    StateEnum? status,
    String? errorMessage,
    String? successMessage,
    String? salutation,
    List<SalutationItem>? salutationsList,
    List<String>? salutationLabels,
  }) {
    return ProfileState(
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      selectedDateOfBirth: selectedDateOfBirth ?? this.selectedDateOfBirth,
      selectedStreet: selectedStreet ?? this.selectedStreet,
      selectedZipCode: selectedZipCode ?? this.selectedZipCode,
      selectedHouse: selectedHouse ?? this.selectedHouse,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedMartialStatus: selectedMartialStatus ?? this.selectedMartialStatus,
      selectedEmployment: selectedEmployment ?? this.selectedEmployment,
      isIOwnVehicle: isIOwnVehicle ?? this.isIOwnVehicle,
      status: status ?? this.status,
      errorMessage: errorMessage??"",
      successMessage: successMessage ?? "",
      salutation: salutation ?? this.salutation,
      salutationsList: salutationsList ?? this.salutationsList,
      salutationLabels: salutationLabels ?? this.salutationLabels,
    );
  }
}