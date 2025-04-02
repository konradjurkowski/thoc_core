import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

/// Result class helps to handle API calls
@sealed
abstract class Result<E extends Object, S> {
  const Result();

  /// Returns the current result.
  dynamic get();

  /// Returns the value of [S].
  S? getSuccess();

  S getSuccessOrThrow();

  /// Returns the value of [E].
  E? getFailure();

  /// Returns true if the current result is an [Failure].
  bool isFailure();

  /// Returns true if the current result is a [success].
  bool isSuccess();

  /// Return the result in one of these functions.
  /// if the result is an result, it will be returned in [whenFailure],
  /// if it is a success it will be returned in [whenSuccess].
  W when<W>(
    W Function(E failure) whenFailure,
    W Function(S success) whenSuccess,
  );

  Result<E, T> map<T>(T Function(S value) mapper) {
    return when(
      (e) => Failure(e),
      (s) => Success(mapper(s)),
    );
  }

  AsyncValue<S> toAsyncValue() {
    return when(
      (e) => AsyncValue.error(e, StackTrace.current),
      (s) => AsyncValue.data(s),
    );
  }
}

/// Success Result.
@immutable
class Success<E extends Object, S> extends Result<E, S> {
  /// Receives the [S] param as
  /// the successful result.
  const Success(this._success);

  final S _success; 

  @override
  S get() {
    return _success;
  }

  @override
  bool isFailure() => false;

  @override
  bool isSuccess() => true;

  @override
  int get hashCode => _success.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Success && other._success == _success;

  @override
  W when<W>(
      W Function(E failure) whenFailure,
      W Function(S success) whenSuccess,
      ) {
    return whenSuccess(_success);
  }

  @override
  E? getFailure() => null;

  @override
  S? getSuccess() => _success;

  @override
  S getSuccessOrThrow() => _success;
}

/// Error Result.
@immutable
class Failure<E extends Object, S> extends Result<E, S> {
  /// Receives the [E] param as
  /// the result result.
  const Failure(this._error);

  final E _error;

  @override
  E get() {
    return _error;
  }

  @override
  bool isFailure() => true;

  @override
  bool isSuccess() => false;

  @override
  int get hashCode => _error.hashCode;

  @override
  bool operator ==(Object other) => other is Failure && other._error == _error;

  @override
  W when<W>(
      W Function(E failure) whenFailure,
      W Function(S succcess) whenSuccess,
      ) {
    return whenFailure(_error);
  }

  @override
  E? getFailure() => _error;

  @override
  S? getSuccess() => null;

  @override
  S getSuccessOrThrow() {
    throw _error;
  }
}
class SuccessResult {
  const SuccessResult._internal();
}

const success = SuccessResult._internal();
