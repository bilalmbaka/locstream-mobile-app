import 'package:locstream/core/error_handlers/exceptions.dart';

import '../enums.dart';
import 'helpers/helpers.dart';

class BaseState<T> {
  final Status status;
  final String? errorMessage;
  final String? message;
  final T? data;

  BaseState({required this.status, this.errorMessage, this.message, this.data});

  factory BaseState.initial({T? data}) {
    return BaseState<T>(status: Status.initial, data: data);
  }

  factory BaseState.loading({T? data}) {
    return BaseState<T>(status: Status.loading, data: data);
  }

  factory BaseState.success(T data, [String? message]) {
    return BaseState<T>(status: Status.success, data: data, message: message);
  }

  factory BaseState.error(
    String errorMessage, {
    T? data,
    Object? e,
    bool showToast = false,
  }) {
    AppHelpers.printToLog(errorMessage.toString());
    return BaseState<T>(
      status: e is NoNetworkException ? Status.noNetwork : Status.error,
      errorMessage: errorMessage,
      data: data,
    );
  }

  bool get isInitial => status == Status.initial;

  bool get isLoading => status == Status.loading;

  bool get isSuccess => status == Status.success;

  bool get isError =>
      status == Status.error ||
      status == Status.blocked ||
      status == Status.unverified ||
      status == Status.noNetwork;

  bool get isNoNetwork => status == Status.noNetwork;

  BaseState<T> copyWith({
    Status? status,
    String? errorMessage,
    String? message,
    T? data, // data parameter is of type T?
  }) {
    return BaseState<T>(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      message: message ?? this.message,
      data: data ?? this.data, // Uses the provided data or the existing data
    );
  }
}
