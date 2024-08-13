import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:image_picker/image_picker.dart';

import '../global/global_vars.dart';

class CommonViewModel {
  // get my location method
  getCurrentLocation() async {
    // get user's current location in lat lon
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = currentPosition;
    //  convert into human readable address
    placemark = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    print('here location $placemark');
    Placemark firstPlacemark = placemark![0];
    fullAddress =
        '${firstPlacemark.subThoroughfare} ${firstPlacemark.thoroughfare}, ${firstPlacemark.subLocality} ${firstPlacemark.locality}, ${firstPlacemark.subAdministrativeArea}, ${firstPlacemark.administrativeArea} ${firstPlacemark.postalCode}, ${firstPlacemark.country}';
    return fullAddress;
  }

  showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // upload image into firebase storage
  uploadImageToFirebaseStorage(XFile imageXFile) async {
    String downloadUrl = '';
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
        .ref()
        .child('sellerImages')
        .child(fileName);
    fStorage.UploadTask uploadTask = storageRef.putFile(File(imageXFile.path));
    fStorage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => {});
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
      downloadUrl = urlImage;
    });
    return downloadUrl;
  }
}
