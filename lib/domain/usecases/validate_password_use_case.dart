import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoc_core/domain/model/validation_result.dart';

class ValidatePasswordUseCase {

  ValidationResult execute(String password, [int length = 8]) {
    if (password.isEmpty) {
      return ValidationResult(error: ValidationError.EMPTY_FIELD);
    }

    final hasMinLength = password.length >= length;
    final hasSpecialCharacter = _hasSpecialCharacter(password);
    final hasDigits = _hasDigits(password);
    final hasUppercaseLetter = _hasUppercaseLetter(password);
    final hasLowercaseLetter = _hasLowercaseLetter(password);

    if (!hasMinLength || !hasSpecialCharacter || !hasDigits || !hasUppercaseLetter || !hasLowercaseLetter) {
      return ValidationResult(error: ValidationError.INVALID_PASSWORD);
    }

    return ValidationResult(successful: true);
  }

  bool _hasDigits(String text) => text.contains(RegExp('[0-9]'));
  bool _hasLowercaseLetter(String text) => text.contains(RegExp('[a-z]'));
  bool _hasUppercaseLetter(String text) => text.contains(RegExp('[A-Z]'));
  bool _hasSpecialCharacter(String text) => text.contains(RegExp('[^A-Za-z0-9]'));
}

final validatePasswordUseCaseProvider = Provider<ValidatePasswordUseCase>((ref) {
  return ValidatePasswordUseCase();
});
