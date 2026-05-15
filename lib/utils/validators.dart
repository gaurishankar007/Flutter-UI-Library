abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
    r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
    r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
    r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
    r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
    r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
    r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])',
  );
  static final RegExp _numberRegex = RegExp('[0-9]');
  static final RegExp _specialCharactersRegex = RegExp(
    r'[!@#$%^&*(),.?":{}|<>]',
  );

  static final RegExp _isAsciiPrintableRegex = RegExp(r'^[\x20-\x7E]+$');

  /// A form field is required with given label
  static String? require(String? value, {required String label}) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required.';
    }
    return null;
  }

  /// Require and format validator for name
  static String? name(String? value, {String label = 'Name'}) {
    final requiredError = require(value, label: label);

    if (requiredError != null) {
      return requiredError;
    } else if (value!.length < 3) {
      return "$label can't have less than 3 characters.";
    } else if (_specialCharactersRegex.hasMatch(value)) {
      return "$label can't have special characters.";
    } else if (_numberRegex.hasMatch(value)) {
      return "$label can't have numbers.";
    }

    return null;
  }

  /// Validate email
  static String? email(String? value) {
    final requiredError = require(value, label: 'Email address');

    if (requiredError != null) {
      return requiredError;
    } else if (!_emailRegex.hasMatch(value!)) {
      return 'Enter a valid email address.';
    }

    return null;
  }

  static String? username(String? value) => require(value, label: 'Username');

  static String? passwordPolicy(String? value) {
    final requiredError = require(value, label: 'Password');

    if (requiredError != null) {
      return requiredError;
    } else if (value!.length <= 6) {
      return 'Password must be at least 7 characters.';
    } else if (!_isAsciiPrintableRegex.hasMatch(value)) {
      return 'Password must contain only letters, numbers and special characters.';
    }

    return null;
  }

  static String? token(String? value) => require(value, label: 'Token');
  static String? password(String? value) => require(value, label: 'Password');
  static String? confirmPassword(String? value) =>
      require(value, label: 'Confirm password');
  static String? currentPassword(String? value) =>
      require(value, label: 'Current password');
  static String? newPassword(String? value) =>
      require(value, label: 'New password');

  /// Validates integer values
  static String? integer(
    String? value, {
    required String label,
    int? minAmount,
    int? maxAmount,
  }) {
    if (value == null || value.isEmpty) {
      return '$label is required.';
    } else if (int.tryParse(value) == null) {
      return 'Invalid ${label.toLowerCase()}. It should only contain integers.';
    } else if (minAmount != null && minAmount > int.parse(value)) {
      return '$label must be at least $minAmount.';
    } else if (maxAmount != null && maxAmount < int.parse(value)) {
      return '$label can be at most $maxAmount.';
    }
    return null;
  }

  static String? age(String? value) =>
      Validators.integer(value, label: 'Age', minAmount: 1, maxAmount: 120);

  /// Validates double values
  static String? doubleValue(
    String? value, {
    required String label,
    double? minAmount,
    double? maxAmount,
  }) {
    if (value == null || value.isEmpty) {
      return '$label is required.';
    } else if (double.tryParse(value) == null) {
      return 'Invalid ${label.toLowerCase()}. It should only contain numbers.';
    } else if (minAmount != null && minAmount > double.parse(value)) {
      return '$label must be at least $minAmount.';
    } else if (maxAmount != null && maxAmount < double.parse(value)) {
      return '$label can be at most $maxAmount.';
    }
    return null;
  }
}
