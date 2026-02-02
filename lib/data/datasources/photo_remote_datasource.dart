import 'package:dio/dio.dart';
import '../models/photo_model.dart';
import '../../core/constants/api_constants.dart';

/// Remote data source for fetching photos from Pexels API
class PhotoRemoteDataSource {
  final Dio _dio;

  PhotoRemoteDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.pexelsBaseUrl,
              connectTimeout: ApiConstants.connectionTimeout,
              receiveTimeout: ApiConstants.receiveTimeout,
              headers: {'Authorization': ApiConstants.pexelsApiKey},
            ),
          );

  /// Get curated photos (for home feed)
  Future<PhotosResponse> getCuratedPhotos({
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.pexelsCurated,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      return PhotosResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Search photos by query
  Future<PhotosResponse> searchPhotos({
    required String query,
    int page = 1,
    int perPage = ApiConstants.defaultPerPage,
    String? orientation,
    String? size,
    String? color,
  }) async {
    try {
      final queryParams = {'query': query, 'page': page, 'per_page': perPage};

      if (orientation != null) queryParams['orientation'] = orientation;
      if (size != null) queryParams['size'] = size;
      if (color != null) queryParams['color'] = color;

      final response = await _dio.get(
        ApiConstants.pexelsSearch,
        queryParameters: queryParams,
      );

      return PhotosResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get a single photo by ID
  Future<PhotoModel> getPhotoById(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.pexelsPhoto}/$id');
      return PhotoModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception(
            'Invalid API key. Please check your Pexels API key.',
          );
        } else if (statusCode == 429) {
          return Exception('Rate limit exceeded. Please try again later.');
        } else if (statusCode == 404) {
          return Exception('Resource not found.');
        }
        return Exception('Server error: $statusCode');
      case DioExceptionType.cancel:
        return Exception('Request cancelled.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('Something went wrong. Please try again.');
    }
  }
}
