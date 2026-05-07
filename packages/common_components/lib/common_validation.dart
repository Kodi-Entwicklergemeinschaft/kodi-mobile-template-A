class CommonValidation {
  CommonValidation._();

  static bool isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  //regex for password validation having minimum 8 characters, 1 uppercase, 1 lowercase, 1 number
  // and one special characters
  static bool isPasswordValid(String password) {
    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password);
  }

  static bool isNameValid(String name) {
    return RegExp(r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$").hasMatch(name);
  }

  static bool isPhoneValid(String phone) {
    return RegExp(r"^\+?[0-9]{7,12}$").hasMatch(phone);
  }

  //regex for DOB validation having format dd/mm/yyyy
  static bool isDOBValid(String dob) {
    return RegExp(r"^(0[1-9]|[12][0-9]|3[01])[-/](0[1-9]|1[012])[-/]\d{4}$")
        .hasMatch(dob);
  }
}
