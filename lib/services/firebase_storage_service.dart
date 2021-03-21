import 'dart:io';

import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pennies_from_heaven/services/firestore_path.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  FirebaseStorageService({required this.uid});
  final String uid;

  /// Upload an avatar from file
  Future<String?> uploadAvatar({required File file}) async => await upload(
        file: file,
        path: FirestorePath.avatar(uid) + '/avatar.png',
        contentType: 'image/png',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    required File file,
    required String path,
    required String contentType,
  }) async {
    firebase_storage.UploadTask uploadTask;

    final storageReference =
        firebase_storage.FirebaseStorage.instance.ref().child(path);

    final metadata =
        firebase_storage.SettableMetadata(contentType: contentType);

    if (kIsWeb) {
      uploadTask = storageReference.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = storageReference.putFile(File(file.path), metadata);
    }

    try {
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
    }
    return '';
    /* if (snapshot. != null) {
      print('upload error code: ${snapshot.error}');
      throw snapshot. error;
    } */
  }
}
