class Validators {
  Validators._();

  static String? validateEmail(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[\w.-]+@[\w.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(
      value.trim(),
    )) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(
    String? value,
  ) {
    if (value == null ||
        value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  static String? validateNote(
    String? value,
  ) {
    if (value == null ||
        value.trim().isEmpty) {
      return 'Session note cannot be empty';
    }

    if (value.trim().length < 5) {
      return 'Please enter at least 5 characters';
    }

    return null;
  }
}