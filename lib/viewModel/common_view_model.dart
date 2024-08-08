import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

  showSnackBar (String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
