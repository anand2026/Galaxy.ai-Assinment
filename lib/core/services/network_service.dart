import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// Network service for API communication
/// Centralizes all HTTP operations with proper error handling
class NetworkService {
  late final Dio _dio;

  NetworkService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.pexelsBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Authorization': ApiConstants.pexelsApiKey,
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Dio get dio => _dio;

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle Dio errors
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkTimeoutException('Connection timed out');
      case DioExceptionType.badResponse:
        return NetworkResponseException(
          'Server error: ${e.response?.statusCode}',
          e.response?.statusCode ?? 0,
        );
      case DioExceptionType.cancel:
        return NetworkCancelledException('Request cancelled');
      default:
        return NetworkException('Network error: ${e.message}');
    }
  }
}

/// Base network exception
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => message;
}

class NetworkTimeoutException extends NetworkException {
  NetworkTimeoutException(super.message);
}

class NetworkResponseException extends NetworkException {
  final int statusCode;
  NetworkResponseException(super.message, this.statusCode);
}

class NetworkCancelledException extends NetworkException {
  NetworkCancelledException(super.message);
}
