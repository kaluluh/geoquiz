abstract class StringValidator {
  bool isValid(String value);
  String get errorText;
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  @override
  String get errorText => 'Can\'t be empty';
}

class RegexValidator implements StringValidator {
  RegexValidator(this.regex);

  final RegExp regex;

  @override
  bool isValid(String value) {
    return regex.hasMatch(value);
  }

  @override
  String get errorText => 'Invalid format';
}

class UsernameValidator extends RegexValidator {
  // Between 3 and 20 characters, only letters, numbers, underscores, and hyphens
  UsernameValidator() : super(RegExp(r'^[a-zA-Z0-9_\-]{3,20}$'));

  @override
  String get errorText => 'Invalid username';
}

class PasswordValidator extends RegexValidator {
  // At least 6 characters, at least one uppercase letter, one lowercase letter and one number, can contain special characters
  PasswordValidator() : super(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z0-9@$!%*#?&]{6,20}$'));

  @override
  String get errorText => 'Password must be at least 6 characters, at least one uppercase letter, one lowercase letter and one number';
}

class EmailValidator extends RegexValidator {
  // Standard email address format
  EmailValidator() : super(RegExp(r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$'));

  @override
  String get errorText => 'Please enter a valid email address';
}

class EmailLoginFormValidators {
  final StringValidator emailValidator = EmailValidator();
  final StringValidator passwordValidator = PasswordValidator();
}