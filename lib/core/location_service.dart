import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService extends GetxService {
  Future<bool> handleLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services Disabled',
        'Please enable location services in your device settings.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.location.request();
      if (result.isGranted) {
        return true;
      }
    }

    if (status.isPermanentlyDenied) {
      await showPermissionDialog();
      return false;
    }

    Get.snackbar(
      'Permission Required',
      'Location permission is needed to get your current city.',
      snackPosition: SnackPosition.BOTTOM,
    );

    return false;
  }

  Future<void> showPermissionDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
            'Location permission is required to get your current city. '
            'Please enable it in your device settings.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<Position?> getCurrentLocation() async {
    try {
      final hasPermission = await handleLocationPermission();
      if (!hasPermission) return null;
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to get current location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
}
