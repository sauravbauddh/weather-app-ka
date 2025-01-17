import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/core/appwrite_controller.dart';
import 'package:weather_app/core/location_service.dart';
import 'package:weather_app/network/storage_service.dart';
import 'package:weather_app/routes/app_pages.dart';
import 'package:weather_app/routes/app_routes.dart';
import 'package:weather_app/screens/home_screen/controller/home_controller.dart';
import 'package:weather_app/widgets/tab_row.dart';

import 'core/theme_controller.dart';
import 'network/api_client.dart';

Future<void> requestPermissions() async {
  final locationStatus = await Permission.location.request();
  if (locationStatus.isPermanentlyDenied) {
    await openAppSettings();
  }
}

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await requestPermissions();
    await ApiClient.init();
    await Get.putAsync(() => StorageService().init());
    Get.put(AppWriteController());
    Get.put(LocationService());

    runApp(
      const MyApp(),
    );
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TabRowController tabRowController = Get.put(TabRowController());
  HomeController homeController = Get.put(HomeController());
  ThemeController themeController = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    checkInitialPermissions();
  }

  Future<void> checkInitialPermissions() async {
    final locationStatus = await Permission.location.status;
    if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
      Get.snackbar(
        'Permissions Required',
        'Location permission is needed for weather updates.',
        duration: const Duration(seconds: 5),
        mainButton: TextButton(
          onPressed: () async {
            await requestPermissions();
          },
          child: const Text('Grant Permission'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.HOME,
        getPages: AppPages.routes,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
