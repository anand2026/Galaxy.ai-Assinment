import '../../domain/entities/photo.dart';

/// Photo data model for Pexels API responses
/// This extends the domain entity with JSON serialization
class PhotoModel extends Photo {
  const PhotoModel({
    required super.id,
    required super.width,
    required super.height,
    required super.url,
    required super.photographer,
    required super.photographerUrl,
    required super.photographerId,
    required super.avgColor,
    required super.src,
    required super.liked,
    required super.alt,
  });

  /// Create PhotoModel from Pexels API JSON response
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String? ?? '',
      photographer: json['photographer'] as String? ?? '',
      photographerUrl: json['photographer_url'] as String? ?? '',
      photographerId: json['photographer_id'] as int? ?? 0,
      avgColor: json['avg_color'] as String? ?? '#FFFFFF',
      src: PhotoSrcModel.fromJson(json['src'] as Map<String, dynamic>),
      liked: json['liked'] as bool? ?? false,
      alt: json['alt'] as String? ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'photographer_id': photographerId,
      'avg_color': avgColor,
      'src': (src as PhotoSrcModel).toJson(),
      'liked': liked,
      'alt': alt,
    };
  }

  /// Copy with new values
  PhotoModel copyWith({
    int? id,
    int? width,
    int? height,
    String? url,
    String? photographer,
    String? photographerUrl,
    int? photographerId,
    String? avgColor,
    PhotoSrc? src,
    bool? liked,
    String? alt,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      width: width ?? this.width,
      height: height ?? this.height,
      url: url ?? this.url,
      photographer: photographer ?? this.photographer,
      photographerUrl: photographerUrl ?? this.photographerUrl,
      photographerId: photographerId ?? this.photographerId,
      avgColor: avgColor ?? this.avgColor,
      src: src ?? this.src,
      liked: liked ?? this.liked,
      alt: alt ?? this.alt,
    );
  }
}

/// Photo source model with JSON serialization
class PhotoSrcModel extends PhotoSrc {
  const PhotoSrcModel({
    required super.original,
    required super.large2x,
    required super.large,
    required super.medium,
    required super.small,
    required super.portrait,
    required super.landscape,
    required super.tiny,
  });

  factory PhotoSrcModel.fromJson(Map<String, dynamic> json) {
    return PhotoSrcModel(
      original: json['original'] as String? ?? '',
      large2x: json['large2x'] as String? ?? '',
      large: json['large'] as String? ?? '',
      medium: json['medium'] as String? ?? '',
      small: json['small'] as String? ?? '',
      portrait: json['portrait'] as String? ?? '',
      landscape: json['landscape'] as String? ?? '',
      tiny: json['tiny'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original': original,
      'large2x': large2x,
      'large': large,
      'medium': medium,
      'small': small,
      'portrait': portrait,
      'landscape': landscape,
      'tiny': tiny,
    };
  }
}

/// Response model for paginated photo lists
class PhotosResponse {
  final int page;
  final int perPage;
  final List<PhotoModel> photos;
  final int totalResults;
  final String? nextPage;
  final String? prevPage;

  const PhotosResponse({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    this.nextPage,
    this.prevPage,
  });

  factory PhotosResponse.fromJson(Map<String, dynamic> json) {
    return PhotosResponse(
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalResults: json['total_results'] as int? ?? 0,
      nextPage: json['next_page'] as String?,
      prevPage: json['prev_page'] as String?,
    );
  }

  bool get hasMore => nextPage != null;
}
