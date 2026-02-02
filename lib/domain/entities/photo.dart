import 'package:equatable/equatable.dart';

/// Photo entity representing a pin/image in the app
/// This is the domain layer entity - clean and framework-independent
class Photo extends Equatable {
  final int id;
  final int width;
  final int height;
  final String url;
  final String photographer;
  final String photographerUrl;
  final int photographerId;
  final String avgColor;
  final PhotoSrc src;
  final bool liked;
  final String alt;

  const Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.photographerId,
    required this.avgColor,
    required this.src,
    required this.liked,
    required this.alt,
  });

  /// Aspect ratio for masonry grid layout
  double get aspectRatio => width / height;

  @override
  List<Object?> get props => [
    id,
    width,
    height,
    url,
    photographer,
    photographerUrl,
    photographerId,
    avgColor,
    src,
    liked,
    alt,
  ];
}

/// Photo source URLs in different sizes
class PhotoSrc extends Equatable {
  final String original;
  final String large2x;
  final String large;
  final String medium;
  final String small;
  final String portrait;
  final String landscape;
  final String tiny;

  const PhotoSrc({
    required this.original,
    required this.large2x,
    required this.large,
    required this.medium,
    required this.small,
    required this.portrait,
    required this.landscape,
    required this.tiny,
  });

  @override
  List<Object?> get props => [
    original,
    large2x,
    large,
    medium,
    small,
    portrait,
    landscape,
    tiny,
  ];
}
