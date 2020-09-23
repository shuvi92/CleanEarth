import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:timwan/models/image_data.dart';
import 'package:uuid/uuid.dart';

class CloudStorageService {
  Future uploadImage({
    @required File image,
    @required String uid,
  }) async {
    var imagePath = "images/$uid/${Uuid().v1()}.jpg";

    try {
      final StorageReference ref =
          FirebaseStorage.instance.ref().child(imagePath);

      StorageUploadTask uploadTask = ref.putFile(image);
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;

      var imageUrl = await snapshot.ref.getDownloadURL();
      if (uploadTask.isComplete) {
        return ImageData(
          imageUrl: imageUrl.toString(),
          imagePath: imagePath,
        );
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteImage({
    @required String imagePath,
  }) async {
    final StorageReference ref =
        FirebaseStorage.instance.ref().child(imagePath);

    try {
      await ref.delete();
      return true;
    } catch (e) {
      e.toString();
    }
  }
}
