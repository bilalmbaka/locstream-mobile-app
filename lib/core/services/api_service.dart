import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../data/data_sources/local_data_sources/auth_local_data_source.dart';
import '../constants/constants.dart';
import '../constants/strings.dart';
import '../error_handlers/api_exception_handler.dart';
import '../error_handlers/exceptions.dart';
import '../utils/helpers/helpers.dart';

class ApiService {
  ApiService({
    this.unAuthorized = false,
    this.dio,
    this.baseUrl,
    this.token,
    this.header,
  }) {
    _dio = dio ?? Dio();

    _dio.options.baseUrl = baseUrl ?? AppConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    _dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
      InterceptorsWrapper(onRequest: (options, handler) async {
        if (unAuthorized) {
          return handler.next(options);
        }

        if (header != null) {
          return handler.next(options.copyWith(headers: header));
        }

        final accessToken = await AuthLocalDataSource().getAuthToken();

        if (accessToken == null) {
          throw IrrecoverableTokenException();
        }

        try {
          final isExpired = JwtDecoder.isExpired(accessToken);

          if (isExpired) {
            final refreshToken = await AuthLocalDataSource().getRefreshToken();

            if (refreshToken == null) throw IrrecoverableTokenException();

            final refreshTokenResponse = (await Dio().patch(
                    '${AppConstants.baseUrl}/auth/refresh-token',
                    data: {'refreshToken': refreshToken}))
                .data;

            final newAccessToken =
                refreshTokenResponse['data']['accessToken'] as String;
            final newRefreshToken =
                refreshTokenResponse['data']['refreshToken'] as String;

            await AuthLocalDataSource().saveAuthToken(newAccessToken);
            await AuthLocalDataSource().saveRefreshToken(newRefreshToken);

            return handler.next(options.copyWith(headers: {
              ...options.headers,
              'Authorization': 'Bearer $newAccessToken'
            }));
          } else {
            return handler.next(options.copyWith(headers: {
              ...options.headers,
              'Authorization': 'Bearer $accessToken'
            }));
          }
        } catch (e) {
          print('Error refreshing token $e ');

          if (e is IrrecoverableTokenException ||
              (e.runtimeType == DioException &&
                  (e as DioException).response?.statusCode == 417)) {
            AppHelpers.forceLogout(
              errorMessage: 'Could not process token'
            );
          }

          return handler.reject(DioException(
              requestOptions: options,
              response: Response(
                  requestOptions: options,
                  statusCode: 403,
                  data: {
                    'success': false,
                    'message': 'Error decoding authorization token'
                  })));
        }
      }, onError: (exception, handler) {
        final response = exception.response;

        if (response == null) return handler.reject(exception);

        if (response.statusCode == 423) {
          AppHelpers.overLayDisabledBanner(
              message: response.data['message'] ?? AppStrings.disabled);
        }

        return handler.reject(exception);
      }),
    ]);
  }

  Dio _dio = Dio();

  final Dio? dio;
  final String? baseUrl;
  final bool unAuthorized;
  final String? token;
  final Map<String, dynamic>? header;

  Future<Map<String, dynamic>> get(String url,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParams,
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }

  Future<Map<String, dynamic>> post(String url, {dynamic data}) async {
    try {
      final response = await _dio.post(url, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }

  Future<Map<String, dynamic>> patch(String url,
      {dynamic data, dynamic queryParams}) async {
    try {
      final response = await _dio.patch(
        url,
        queryParameters: queryParams,
        data: data,
      );

      return _handleResponse(response);
    } catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }

  Future<Map<String, dynamic>> _handleResponse(Response response) async {
    final data = response.data;
    if ((data is Map<String, dynamic>) == false) {
      return {'data': data};
    }

    if (data['success']) {
      return data;
    } else {
      throw DioException(
          requestOptions: RequestOptions(path: response.requestOptions.path),
          response: response,
          type: DioExceptionType.badResponse,
          error: data['message']);
    }
  }
}
