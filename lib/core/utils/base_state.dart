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
    bool showToast = false,
  }) {
    AppHelpers.printToLog(errorMessage.toString());
    return BaseState<T>(
      status: Status.error,
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
}
