import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/services/storage_service.dart';
import 'features/auth/auth_controller.dart';
import 'features/profile/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Persistent Services
  await Get.putAsync(() => StorageService().init());
  Get.put(ProfileController(), permanent: true);
  Get.put(AuthController());
  runApp(const App());
}
