import '../entities/photo.dart';
import '../repositories/photo_repository.dart';

/// Use case for getting curated photos for the home feed
class GetCuratedPhotosUseCase {
  final PhotoRepository repository;

  GetCuratedPhotosUseCase(this.repository);

  Future<PhotosResult> execute({int page = 1, int perPage = 20}) {
    return repository.getCuratedPhotos(page: page, perPage: perPage);
  }
}

/// Use case for searching photos
class SearchPhotosUseCase {
  final PhotoRepository repository;

  SearchPhotosUseCase(this.repository);

  Future<PhotosResult> execute(String query, {int page = 1, int perPage = 20}) {
    return repository.searchPhotos(query: query, page: page, perPage: perPage);
  }
}

/// Use case for getting a single photo by ID
class GetPhotoByIdUseCase {
  final PhotoRepository repository;

  GetPhotoByIdUseCase(this.repository);

  Future<Photo> execute(int id) {
    return repository.getPhotoById(id);
  }
}

/// Use case for getting related photos
class GetRelatedPhotosUseCase {
  final PhotoRepository repository;

  GetRelatedPhotosUseCase(this.repository);

  Future<PhotosResult> execute(String query, {int page = 1, int perPage = 20}) {
    // Use search with the photo's alt text or category
    return repository.searchPhotos(query: query, page: page, perPage: perPage);
  }
}
