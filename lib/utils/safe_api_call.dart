import 'package:dio/dio.dart';
import 'package:thoc_core/utils/exceptions/api_exception.dart';
import 'package:thoc_core/utils/result.dart';

Future<Result<ApiException, T>> safeApiCall<T>(
  Future<Response> Function() apiCall, {
  required T Function(dynamic) mapper,
}) async {
  try {
    final response = await apiCall();
    if (response.isSuccessful && response.data != null) {
      return Success(mapper(response.data));
    } else {
      return const Failure(ApiException(type: ApiExceptionType.failure));
    }
  } on DioException catch (e) {
    return Failure(e.getFailureException());
  } catch (e) {
    return Failure(
      ApiException(
        type: ApiExceptionType.unknown,
        message: e.toString(),
      ),
    );
  }
}

extension ResponseHelper on Response {
  bool get isSuccessful => (statusCode ?? 0) >= 200 && (statusCode ?? 0) < 300;
}
