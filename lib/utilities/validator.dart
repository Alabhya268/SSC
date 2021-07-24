class Validator {
  String validatePassword(String value) {
    RegExp regex = new RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) return 'Enter valid password';
    }
    return '';
  }

  String validateEmail(String value) {
    RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (value.isEmpty) {
      return 'Please enter email';
    } else {
      if (!regex.hasMatch(value)) return 'Enter valid email';
    }
    return '';
  }
}
