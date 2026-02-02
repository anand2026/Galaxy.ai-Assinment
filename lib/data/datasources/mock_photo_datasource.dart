import '../../domain/entities/photo.dart';
import '../models/photo_model.dart';

/// Mock data source for demo purposes when API key is not available
class MockPhotoDataSource {
  static List<PhotoModel> getMockPhotos({int count = 20}) {
    // List of sample Pexels photo URLs that are publicly accessible
    final mockPhotos = <PhotoModel>[
      _createMockPhoto(
        id: 1,
        photographer: 'Pixabay',
        alt: 'Beautiful mountain landscape',
        avgColor: '#3B4A5A',
        width: 1920,
        height: 1280,
        url: 'https://images.pexels.com/photos/417074/pexels-photo-417074.jpeg',
      ),
      _createMockPhoto(
        id: 2,
        photographer: 'Jaime Reimer',
        alt: 'Ocean waves at sunset',
        avgColor: '#2B5D7D',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/1198507/pexels-photo-1198507.jpeg',
      ),
      _createMockPhoto(
        id: 3,
        photographer: 'Elia Clerici',
        alt: 'City skyline at night',
        avgColor: '#1A2937',
        width: 1920,
        height: 1280,
        url: 'https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg',
      ),
      _createMockPhoto(
        id: 4,
        photographer: 'Snapwire',
        alt: 'Fresh fruits on table',
        avgColor: '#D4A373',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/7753100/pexels-photo-7753100.jpeg',
      ),
      _createMockPhoto(
        id: 5,
        photographer: 'Taryn Elliott',
        alt: 'Minimalist interior design',
        avgColor: '#E8DED1',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/4440720/pexels-photo-4440720.jpeg',
      ),
      _createMockPhoto(
        id: 6,
        photographer: 'Josh Hild',
        alt: 'Forest path in autumn',
        avgColor: '#7A5C3C',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/1624496/pexels-photo-1624496.jpeg',
      ),
      _createMockPhoto(
        id: 7,
        photographer: 'eberhard grossgasteiger',
        alt: 'Snow-capped mountains',
        avgColor: '#4A6572',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/1366909/pexels-photo-1366909.jpeg',
      ),
      _createMockPhoto(
        id: 8,
        photographer: 'Valeria Boltneva',
        alt: 'Delicious coffee setup',
        avgColor: '#3E2723',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/1420709/pexels-photo-1420709.jpeg',
      ),
      _createMockPhoto(
        id: 9,
        photographer: 'Max',
        alt: 'Cute dog portrait',
        avgColor: '#8D6E63',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/1805164/pexels-photo-1805164.jpeg',
      ),
      _createMockPhoto(
        id: 10,
        photographer: 'Mark Neal',
        alt: 'Abstract art painting',
        avgColor: '#E91E63',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/2911521/pexels-photo-2911521.jpeg',
      ),
      _createMockPhoto(
        id: 11,
        photographer: 'Tom Fisk',
        alt: 'Aerial view of beach',
        avgColor: '#00BCD4',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/1430677/pexels-photo-1430677.jpeg',
      ),
      _createMockPhoto(
        id: 12,
        photographer: 'Daria Shevtsova',
        alt: 'Healthy breakfast bowl',
        avgColor: '#FFEB3B',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/1640770/pexels-photo-1640770.jpeg',
      ),
      _createMockPhoto(
        id: 13,
        photographer: 'Sebastian Voortman',
        alt: 'Modern architecture building',
        avgColor: '#607D8B',
        width: 1920,
        height: 1280,
        url: 'https://images.pexels.com/photos/164338/pexels-photo-164338.jpeg',
      ),
      _createMockPhoto(
        id: 14,
        photographer: 'Pixabay',
        alt: 'Colorful flowers garden',
        avgColor: '#E91E63',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/56866/garden-rose-red-pink-56866.jpeg',
      ),
      _createMockPhoto(
        id: 15,
        photographer: 'Alex Andrews',
        alt: 'Relaxing spa setup',
        avgColor: '#9E9E9E',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/3188/love-romantic-bath-bathtub.jpg',
      ),
      _createMockPhoto(
        id: 16,
        photographer: 'Oladimeji Ajegbile',
        alt: 'Fashion streetwear style',
        avgColor: '#795548',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/1549200/pexels-photo-1549200.jpeg',
      ),
      _createMockPhoto(
        id: 17,
        photographer: 'Magda Ehlers',
        alt: 'Tropical palm trees',
        avgColor: '#4CAF50',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/1038000/pexels-photo-1038000.jpeg',
      ),
      _createMockPhoto(
        id: 18,
        photographer: 'Andrea Piacquadio',
        alt: 'Person working on laptop',
        avgColor: '#F5F5F5',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/3746/woman-hand-smartphone-laptop.jpeg',
      ),
      _createMockPhoto(
        id: 19,
        photographer: 'Karolina Kaboompics',
        alt: 'Cozy home decor',
        avgColor: '#FFCCBC',
        width: 1920,
        height: 1280,
        url:
            'https://images.pexels.com/photos/1090638/pexels-photo-1090638.jpeg',
      ),
      _createMockPhoto(
        id: 20,
        photographer: 'Fabian Wiktor',
        alt: 'Night city lights',
        avgColor: '#1A237E',
        width: 1920,
        height: 2880,
        url:
            'https://images.pexels.com/photos/3408744/pexels-photo-3408744.jpeg',
      ),
    ];

    return mockPhotos.take(count).toList();
  }

  static PhotoModel _createMockPhoto({
    required int id,
    required String photographer,
    required String alt,
    required String avgColor,
    required int width,
    required int height,
    required String url,
  }) {
    return PhotoModel(
      id: id,
      width: width,
      height: height,
      url: url,
      photographer: photographer,
      photographerUrl: 'https://www.pexels.com/@$photographer',
      photographerId: id * 100,
      avgColor: avgColor,
      src: PhotoSrc(
        original: url,
        large2x: '$url?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
        large: '$url?auto=compress&cs=tinysrgb&h=650&w=940',
        medium: '$url?auto=compress&cs=tinysrgb&h=350',
        small: '$url?auto=compress&cs=tinysrgb&h=130',
        portrait: '$url?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800',
        landscape: '$url?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
        tiny: '$url?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280',
      ),
      alt: alt,
      liked: false,
    );
  }

  static PhotosResponse getMockPhotosResponse({
    int page = 1,
    int perPage = 20,
  }) {
    return PhotosResponse(
      photos: getMockPhotos(count: perPage),
      page: page,
      perPage: perPage,
      totalResults: 100,
      nextPage: page < 5 ? 'mock://next_page' : null,
    );
  }
}
