import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({this.message, this.error, required this.type});

  final String? message;
  final Error? error;
  final ApiExceptionType type;

  @override
  String toString() {
    return 'ApiException{message: $message, result: $error, type: $type}';
  }
}

extension DioExceptionX on DioException {
  bool get isNoConnectionError =>
      type == DioExceptionType.connectionError && error is SocketException;

  ApiException getFailureException() {
    if (isNoConnectionError) {
      return const ApiException(type: ApiExceptionType.noInternet);
    }

    return ApiException(
      message: error?.toString(),
      type: ApiExceptionType.getType(type),
    );
  }
}

enum ApiExceptionType {
  noInternet,
  notAuthenticated,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  badResponse,
  cancel,
  connectionError,
  unknown,
  failure;

  static ApiExceptionType getType(DioExceptionType exceptionType) {
    return ApiExceptionType.values.firstWhere(
      (type) => type.name == exceptionType.name,
      orElse: () => ApiExceptionType.unknown,
    );
  }
}
