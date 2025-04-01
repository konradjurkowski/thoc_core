import 'package:email_validator/email_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoc_core/domain/model/validation_result.dart';

class ValidateEmailUseCase {

  ValidationResult execute(String email) {
    if (email.isEmpty) {
      return ValidationResult(error: ValidationError.EMPTY_FIELD);
    }

    if (!EmailValidator.validate(email)) {
      return ValidationResult(error: ValidationError.INVALID_EMAIL);
    }

    return ValidationResult(successful: true);
  }
}

final validateEmailUseCaseProvider = Provider<ValidateEmailUseCase>((ref) {
  return ValidateEmailUseCase();
});
