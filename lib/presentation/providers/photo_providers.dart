import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/photo_remote_datasource.dart';
import '../../data/repositories/photo_repository_impl.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photo_repository.dart';

/// Photo repository provider
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepositoryImpl(remoteDataSource: PhotoRemoteDataSource());
});

/// State for home feed
class HomeFeedState {
  final List<Photo> photos;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const HomeFeedState({
    this.photos = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  HomeFeedState copyWith({
    List<Photo>? photos,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return HomeFeedState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Home feed notifier
class HomeFeedNotifier extends StateNotifier<HomeFeedState> {
  final PhotoRepository _repository;

  HomeFeedNotifier(this._repository) : super(const HomeFeedState());

  Future<void> loadPhotos() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _repository.getCuratedPhotos(page: 1);
      state = state.copyWith(
        photos: result.photos,
        isLoading: false,
        currentPage: result.page,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.getCuratedPhotos(
        page: state.currentPage + 1,
      );
      state = state.copyWith(
        photos: [...state.photos, ...result.photos],
        isLoadingMore: false,
        currentPage: result.page,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = const HomeFeedState(isLoading: true);
    await loadPhotos();
  }
}

/// Home feed provider
final homeFeedProvider = StateNotifierProvider<HomeFeedNotifier, HomeFeedState>(
  (ref) {
    final repository = ref.watch(photoRepositoryProvider);
    return HomeFeedNotifier(repository);
  },
);

/// State for search
class SearchState {
  final List<Photo> photos;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String query;
  final int currentPage;
  final bool hasMore;
  final List<String> recentSearches;

  const SearchState({
    this.photos = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.query = '',
    this.currentPage = 1,
    this.hasMore = true,
    this.recentSearches = const [],
  });

  SearchState copyWith({
    List<Photo>? photos,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? query,
    int? currentPage,
    bool? hasMore,
    List<String>? recentSearches,
  }) {
    return SearchState(
      photos: photos ?? this.photos,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      query: query ?? this.query,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

/// Search notifier
class SearchNotifier extends StateNotifier<SearchState> {
  final PhotoRepository _repository;

  SearchNotifier(this._repository) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.isEmpty || state.isLoading) return;

    // Add to recent searches
    final recentSearches = [
      query,
      ...state.recentSearches.where((s) => s != query).take(9),
    ];

    state = state.copyWith(
      isLoading: true,
      query: query,
      error: null,
      recentSearches: recentSearches,
    );

    try {
      final result = await _repository.searchPhotos(query: query, page: 1);
      state = state.copyWith(
        photos: result.photos,
        isLoading: false,
        currentPage: result.page,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.searchPhotos(
        query: state.query,
        page: state.currentPage + 1,
      );
      state = state.copyWith(
        photos: [...state.photos, ...result.photos],
        isLoadingMore: false,
        currentPage: result.page,
        hasMore: result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    }
  }

  void clearSearch() {
    state = state.copyWith(
      photos: [],
      query: '',
      currentPage: 1,
      hasMore: true,
    );
  }

  void clearRecentSearches() {
    state = state.copyWith(recentSearches: []);
  }
}

/// Search provider
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final repository = ref.watch(photoRepositoryProvider);
  return SearchNotifier(repository);
});

/// Related photos notifier (for 'More like this' section)
class RelatedPhotosNotifier extends StateNotifier<AsyncValue<List<Photo>>> {
  final PhotoRepository _repository;

  RelatedPhotosNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> loadRelatedPhotos(String query) async {
    state = const AsyncValue.loading();
    try {
      // If query is empty, fetch curated/random photos instead
      final result = query.isNotEmpty
          ? await _repository.searchPhotos(query: query, page: 1, perPage: 10)
          : await _repository.getCuratedPhotos(page: 2, perPage: 10);

      state = AsyncValue.data(result.photos);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Related photos provider
final relatedPhotosProvider =
    StateNotifierProvider.autoDispose<
      RelatedPhotosNotifier,
      AsyncValue<List<Photo>>
    >((ref) {
      final repository = ref.watch(photoRepositoryProvider);
      return RelatedPhotosNotifier(repository);
    });

/// Selected photo provider (for detail view)
final selectedPhotoProvider = StateProvider<Photo?>((ref) => null);

/// Navigation index provider
final navigationIndexProvider = StateProvider<int>((ref) => 0);
