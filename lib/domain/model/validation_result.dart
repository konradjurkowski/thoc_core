class ValidationResult {
  const ValidationResult({
    this.successful = false,
    this.error,
  });

  final bool successful;
  final ValidationError? error;
}

enum ValidationError {
  EMPTY_FIELD,
  INVALID_EMAIL,
  INVALID_PASSWORD,
}
