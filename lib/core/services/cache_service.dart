import 'package:flutter/foundation.dart';

/// Cache service for local data storage
/// Provides in-memory caching with TTL support
class CacheService {
  final Map<String, CacheEntry> _cache = {};

  /// Default cache duration
  static const Duration defaultTTL = Duration(minutes: 5);

  /// Get cached data
  T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.data as T?;
  }

  /// Set cached data with optional TTL
  void set<T>(String key, T data, {Duration? ttl}) {
    _cache[key] = CacheEntry(
      data: data,
      expiry: DateTime.now().add(ttl ?? defaultTTL),
    );
  }

  /// Remove cached data
  void remove(String key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Check if key exists and is valid
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.isExpired) {
      _cache.remove(key);
      return false;
    }
    return true;
  }

  /// Get cache statistics
  CacheStats get stats => CacheStats(
    totalEntries: _cache.length,
    validEntries: _cache.values.where((e) => !e.isExpired).length,
  );
}

/// Cache entry with expiry
class CacheEntry {
  final dynamic data;
  final DateTime expiry;

  CacheEntry({required this.data, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}

/// Cache statistics
class CacheStats {
  final int totalEntries;
  final int validEntries;

  CacheStats({required this.totalEntries, required this.validEntries});
}

/// Image cache helper for cached_network_image
class ImageCacheService {
  static const int maxCacheSize = 100; // Max images to cache
  static const Duration imageCacheDuration = Duration(days: 7);

  /// Get cache key for image URL
  static String getCacheKey(String url) {
    return url.hashCode.toString();
  }

  /// Preload images for better performance
  static Future<void> preloadImages(List<String> urls) async {
    // cached_network_image handles this automatically
    // This method can be used for additional preloading logic
    debugPrint('Preloading ${urls.length} images');
  }
}
