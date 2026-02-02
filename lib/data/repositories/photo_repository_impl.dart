import '../datasources/photo_remote_datasource.dart';
import '../datasources/mock_photo_datasource.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';
import '../../core/constants/api_constants.dart';

/// Implementation of PhotoRepository with mock data fallback
class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource _remoteDataSource;
  bool _useMockData = false;

  PhotoRepositoryImpl({PhotoRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? PhotoRemoteDataSource() {
    // Auto-detect if API key is configured using helper method
    _useMockData = !ApiConstants.isPexelsConfigured;
  }

  @override
  Future<PhotosResult> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  }) async {
    // Use mock data if API key is not configured
    if (_useMockData) {
      return _getMockPhotosResult(page: page, perPage: perPage);
    }

    try {
      final response = await _remoteDataSource.getCuratedPhotos(
        page: page,
        perPage: perPage,
      );

      return PhotosResult(
        photos: response.photos,
        page: response.page,
        perPage: response.perPage,
        totalResults: response.totalResults,
        hasMore: response.hasMore,
      );
    } catch (e) {
      // Fallback to mock data on API error
      if (e.toString().contains('Invalid API key')) {
        _useMockData = true;
        return _getMockPhotosResult(page: page, perPage: perPage);
      }
      rethrow;
    }
  }

  @override
  Future<PhotosResult> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    // Use mock data if API key is not configured
    if (_useMockData) {
      return _getMockSearchResult(query: query, page: page, perPage: perPage);
    }

    try {
      final response = await _remoteDataSource.searchPhotos(
        query: query,
        page: page,
        perPage: perPage,
      );

      return PhotosResult(
        photos: response.photos,
        page: response.page,
        perPage: response.perPage,
        totalResults: response.totalResults,
        hasMore: response.hasMore,
      );
    } catch (e) {
      // Fallback to mock data on API error
      if (e.toString().contains('Invalid API key')) {
        _useMockData = true;
        return _getMockSearchResult(query: query, page: page, perPage: perPage);
      }
      rethrow;
    }
  }

  @override
  Future<Photo> getPhotoById(int id) async {
    if (_useMockData) {
      final mockPhotos = MockPhotoDataSource.getMockPhotos();
      return mockPhotos.firstWhere(
        (p) => p.id == id,
        orElse: () => mockPhotos.first,
      );
    }

    try {
      return await _remoteDataSource.getPhotoById(id);
    } catch (e) {
      if (e.toString().contains('Invalid API key')) {
        _useMockData = true;
        final mockPhotos = MockPhotoDataSource.getMockPhotos();
        return mockPhotos.firstWhere(
          (p) => p.id == id,
          orElse: () => mockPhotos.first,
        );
      }
      rethrow;
    }
  }

  PhotosResult _getMockPhotosResult({int page = 1, int perPage = 20}) {
    final allPhotos = MockPhotoDataSource.getMockPhotos(count: 20);

    // Shuffle photos for different pages to simulate pagination
    final shuffledPhotos = List<Photo>.from(allPhotos);
    if (page > 1) {
      shuffledPhotos.shuffle();
    }

    return PhotosResult(
      photos: shuffledPhotos.take(perPage).toList(),
      page: page,
      perPage: perPage,
      totalResults: 100,
      hasMore: page < 5,
    );
  }

  PhotosResult _getMockSearchResult({
    required String query,
    int page = 1,
    int perPage = 20,
  }) {
    final allPhotos = MockPhotoDataSource.getMockPhotos(count: 20);

    // Filter photos that match the query in alt text
    final filteredPhotos = allPhotos.where((photo) {
      return photo.alt.toLowerCase().contains(query.toLowerCase()) ||
          photo.photographer.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // If no matches, return all photos
    final photosToReturn = filteredPhotos.isEmpty ? allPhotos : filteredPhotos;

    return PhotosResult(
      photos: photosToReturn.take(perPage).toList(),
      page: page,
      perPage: perPage,
      totalResults: photosToReturn.length,
      hasMore: page == 1 && photosToReturn.length > perPage,
    );
  }
}
