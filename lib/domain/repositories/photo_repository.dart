import '../../domain/entities/photo.dart';

/// Photo repository interface (domain layer)
abstract class PhotoRepository {
  /// Get curated photos for home feed
  Future<PhotosResult> getCuratedPhotos({int page = 1, int perPage = 20});

  /// Search photos by query
  Future<PhotosResult> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
  });

  /// Get photo by ID
  Future<Photo> getPhotoById(int id);
}

/// Result wrapper for paginated photo results
class PhotosResult {
  final List<Photo> photos;
  final int page;
  final int perPage;
  final int totalResults;
  final bool hasMore;

  const PhotosResult({
    required this.photos,
    required this.page,
    required this.perPage,
    required this.totalResults,
    required this.hasMore,
  });
}
