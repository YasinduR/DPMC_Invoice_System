import 'package:geolocator/geolocator.dart';

// lib/services/location_service.dart
//import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> _isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<bool> _checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<bool> initializeLocationAndPermissions() async {
    bool serviceEnabled = await _isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    bool permissionGranted = await _checkAndRequestLocationPermission();
    if (!permissionGranted) {
      return false;
    }
    return true;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

 Future<bool> areLocationServicesAndPermissionsReady() async {
   bool serviceEnabled = await _isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // Services are off
    }
    bool permissionGranted = await _checkAndRequestLocationPermission();
    if (!permissionGranted) {
      return false; // Permissions are not granted
    }
    return true; // All good
  }

 Future<List<double?>?> getCurrentLocationCoordinates() async {
    bool locationReady = await areLocationServicesAndPermissionsReady();
    if (!locationReady) {
      return null;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      return [position.latitude, position.longitude];
    } catch (e) {
      return null;
    }
  }
}