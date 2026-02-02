/// API configuration and endpoints
///
/// To use real Pexels API:
/// 1. Get a free API key from https://www.pexels.com/api/
/// 2. Replace 'YOUR_PEXELS_API_KEY' below with your actual key
///
/// The app automatically falls back to mock data if no API key is configured.
class ApiConstants {
  ApiConstants._();

  // ========== PEXELS API ==========
  // Get your free API key at: https://www.pexels.com/api/
  static const String pexelsBaseUrl = 'https://api.pexels.com/v1';

  // TODO: Replace with your actual Pexels API key
  static const String pexelsApiKey = String.fromEnvironment(
    'PEXELS_API_KEY',
    defaultValue: 'M9BxSS8GlNcK6S4otn7HZGG1jmr7Gh3KI1aNNcBfWdeuLvWepVtx0BO2',
  );

  // Pexels endpoints
  static const String pexelsCurated = '/curated';
  static const String pexelsSearch = '/search';
  static const String pexelsPhoto = '/photos';

  // ========== UNSPLASH API (Alternative) ==========
  // Get your API key at: https://unsplash.com/developers
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static const String unsplashAccessKey = String.fromEnvironment(
    'UNSPLASH_ACCESS_KEY',
    defaultValue: 'YOUR_UNSPLASH_ACCESS_KEY',
  );

  // Unsplash endpoints
  static const String unsplashPhotos = '/photos';
  static const String unsplashSearch = '/search/photos';
  static const String unsplashRandom = '/photos/random';

  // ========== PAGINATION ==========
  static const int defaultPerPage = 20;
  static const int maxPerPage = 80;

  // ========== TIMEOUTS ==========
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ========== HELPER METHODS ==========

  /// Check if Pexels API key is configured
  static bool get isPexelsConfigured =>
      pexelsApiKey != 'YOUR_PEXELS_API_KEY' && pexelsApiKey.isNotEmpty;

  /// Check if Unsplash API key is configured
  static bool get isUnsplashConfigured =>
      unsplashAccessKey != 'YOUR_UNSPLASH_ACCESS_KEY' &&
      unsplashAccessKey.isNotEmpty;
}
