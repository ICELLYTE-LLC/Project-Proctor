import '../models/photo_model.dart';

class PhotoService {
  // Singleton pattern
  static final PhotoService _instance = PhotoService._internal();
  factory PhotoService() => _instance;
  PhotoService._internal();

  // TODO: Add Firebase Firestore instance when implementing Firebase
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all photos
  // When Firebase is added, this will query Firestore
  Future<List<PhotoModel>> getPhotos({String? projectId}) async {
    // TODO: Replace with Firebase query
    // Example Firebase implementation:
    // Query query = _firestore.collection('photos');
    // if (projectId != null) {
    //   query = query.where('projectId', isEqualTo: projectId);
    // }
    // final snapshot = await query.get();
    // return snapshot.docs.map((doc) => PhotoModel.fromMap(doc.data(), doc.id)).toList();

    // Current local data
    return _getLocalPhotos();
  }

  // Add a new photo
  // When Firebase is added, this will upload to Storage and save to Firestore
  Future<PhotoModel> addPhoto({
    required String title,
    required String date,
    required String imageUrl,
    String? projectId,
  }) async {
    // TODO: Replace with Firebase implementation
    // Example Firebase implementation:
    // 1. Upload image to Firebase Storage
    // final storageRef = _storage.ref().child('photos/${DateTime.now().millisecondsSinceEpoch}');
    // await storageRef.putFile(File(imageUrl));
    // final downloadUrl = await storageRef.getDownloadURL();
    //
    // 2. Save photo data to Firestore
    // final docRef = await _firestore.collection('photos').add({
    //   'title': title,
    //   'date': date,
    //   'imageUrl': downloadUrl,
    //   'projectId': projectId,
    //   'uploadedAt': FieldValue.serverTimestamp(),
    // });
    //
    // 3. Return the created photo
    // final doc = await docRef.get();
    // return PhotoModel.fromMap(doc.data()!, doc.id);

    // Current implementation
    final photo = PhotoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: date,
      imageUrl: imageUrl,
      projectId: projectId,
      uploadedAt: DateTime.now(),
    );

    return photo;
  }

  // Update a photo
  // When Firebase is added, this will update Firestore document
  Future<void> updatePhoto(PhotoModel photo) async {
    // TODO: Replace with Firebase implementation
    // Example Firebase implementation:
    // await _firestore.collection('photos').doc(photo.id).update({
    //   'title': photo.title,
    //   'date': photo.date,
    //   'updatedAt': FieldValue.serverTimestamp(),
    // });

    // Current implementation - no-op for local data
    return;
  }

  // Delete a photo
  // When Firebase is added, this will delete from Storage and Firestore
  Future<void> deletePhoto(String photoId) async {
    // TODO: Replace with Firebase implementation
    // Example Firebase implementation:
    // 1. Get photo document to retrieve storage URL
    // final doc = await _firestore.collection('photos').doc(photoId).get();
    // final photoData = doc.data();
    //
    // 2. Delete from Storage
    // if (photoData?['imageUrl'] != null) {
    //   await _storage.refFromURL(photoData!['imageUrl']).delete();
    // }
    //
    // 3. Delete from Firestore
    // await _firestore.collection('photos').doc(photoId).delete();

    // Current implementation - no-op for local data
    return;
  }

  // Upload multiple photos
  // When Firebase is added, this will batch upload to Storage and Firestore
  Future<List<PhotoModel>> uploadMultiplePhotos({
    required List<String> imagePaths,
    String? projectId,
  }) async {
    // TODO: Replace with Firebase batch upload
    // Example Firebase implementation:
    // final List<PhotoModel> uploadedPhotos = [];
    //
    // for (final imagePath in imagePaths) {
    //   final photo = await addPhoto(
    //     title: 'Photo ${DateTime.now().millisecondsSinceEpoch}',
    //     date: _formatDate(DateTime.now()),
    //     imageUrl: imagePath,
    //     projectId: projectId,
    //   );
    //   uploadedPhotos.add(photo);
    // }
    //
    // return uploadedPhotos;

    // Current implementation
    return [];
  }

  // Helper: Get local photos (current implementation)
  List<PhotoModel> _getLocalPhotos() {
    return [
      PhotoModel.fromAsset(
        id: '1',
        title: 'Foundation complete',
        date: 'Oct 15',
        assetPath: 'assets/images/Foundation complete.png',
      ),
      PhotoModel.fromAsset(
        id: '2',
        title: 'Interior framing progress',
        date: 'Nov 8',
        assetPath: 'assets/images/Interior framing progress.png',
      ),
      PhotoModel.fromAsset(
        id: '3',
        title: 'Tool inventory',
        date: 'Nov 10',
        assetPath: 'assets/images/Tool inventory.png',
      ),
      PhotoModel.fromAsset(
        id: '4',
        title: 'Exterior facade',
        date: 'Nov 12',
        assetPath: 'assets/images/Exterior facade.png',
      ),
      PhotoModel.fromAsset(
        id: '5',
        title: 'Materials delivery',
        date: 'Nov 13',
        assetPath: 'assets/images/Materials delivery.png',
      ),
      PhotoModel.fromAsset(
        id: '6',
        title: 'Overall site view',
        date: 'Nov 15',
        assetPath: 'assets/images/Overall site view.png',
      ),
      PhotoModel.fromAsset(
        id: '7',
        title: 'Construction progress',
        date: 'Nov 14',
        assetPath: 'assets/images/Construction progress.png',
      ),
      PhotoModel.fromAsset(
        id: '8',
        title: 'Site inspection',
        date: 'Nov 16',
        assetPath: 'assets/images/Site inspection.png',
      ),
    ];
  }

}
