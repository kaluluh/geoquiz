import 'package:flutter_test/flutter_test.dart';
import 'package:geoquiz/services/firebase/validators.dart';

void main(){
  // Validator tests
  test('Email validator - empty', () {
    EmailValidator emailValidator = EmailValidator();
    expect(emailValidator.isValid(''), false);
  });

  test('Email validator - non-email string', () {
    EmailValidator emailValidator = EmailValidator();
    expect(emailValidator.isValid('test'), false);
  });

  test('Email validator - invalid domain', () {
    EmailValidator emailValidator = EmailValidator();
    expect(emailValidator.isValid('test@test'), false);
  });

  test('Email validator - valid email', () {
    EmailValidator emailValidator = EmailValidator();
    expect(emailValidator.isValid('test@test.com'), true);
  });

  test('Password validator - empty', () {
    PasswordValidator passwordValidator = PasswordValidator();
    expect(passwordValidator.isValid(''), false);
  });

  test('Password validator - too short', () {
    PasswordValidator passwordValidator = PasswordValidator();
    expect(passwordValidator.isValid('test'), false);
  });

  test('Password validator - no uppercase', () {
    PasswordValidator passwordValidator = PasswordValidator();
    expect(passwordValidator.isValid('testtest'), false);
  });

  test('Password validator - no lowercase', () {
    PasswordValidator passwordValidator = PasswordValidator();
    expect(passwordValidator.isValid('TESTTEST'), false);
  });

  test('Password validator - no number', () {
    PasswordValidator passwordValidator = PasswordValidator();
    expect(passwordValidator.isValid('TESTTEST'), false);
  });

  test('Password validator - valid password', () {
    PasswordValidator passwordValidator = PasswordValidator();
    expect(passwordValidator.isValid('TestTest1'), true);
  });

  test('Username validator - empty', () {
    UsernameValidator usernameValidator = UsernameValidator();
    expect(usernameValidator.isValid(''), false);
  });

  test('Username validator - too short', () {
    UsernameValidator usernameValidator = UsernameValidator();
    expect(usernameValidator.isValid('te'), false);
  });

  test('Username validator - too long', () {
    UsernameValidator usernameValidator = UsernameValidator();
    expect(usernameValidator.isValid('asdfqwerojdfgoaqjerngojadefnbojsndfolg'), false);
  });

  test('Username validator - invalid characters', () {
    UsernameValidator usernameValidator = UsernameValidator();
    expect(usernameValidator.isValid('test!'), false);
  });

  test('Username validator - valid username', () {
    UsernameValidator usernameValidator = UsernameValidator();
    expect(usernameValidator.isValid('Test-ing_123'), true);
  });
}