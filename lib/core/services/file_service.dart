/// File service for media handling
/// Manages file operations for images, videos, and other media
class FileService {
  /// Get file size in human readable format
  static String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if file is an image
  static bool isImage(String path) {
    final ext = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  /// Check if file is a video
  static bool isVideo(String path) {
    final ext = path.toLowerCase().split('.').last;
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);
  }

  /// Get file extension
  static String getExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  /// Get MIME type from extension
  static String getMimeType(String path) {
    final ext = getExtension(path);
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }

  /// Calculate aspect ratio from dimensions
  static double calculateAspectRatio(int width, int height) {
    if (height == 0) return 1.0;
    return width / height;
  }

  /// Get optimal image dimensions for display
  static Size getOptimalSize(
    int originalWidth,
    int originalHeight,
    double maxWidth,
  ) {
    if (originalWidth <= maxWidth) {
      return Size(originalWidth.toDouble(), originalHeight.toDouble());
    }

    final ratio = maxWidth / originalWidth;
    return Size(maxWidth, originalHeight * ratio);
  }
}

/// Size helper class
class Size {
  final double width;
  final double height;

  Size(this.width, this.height);

  double get aspectRatio => height == 0 ? 1.0 : width / height;
}
