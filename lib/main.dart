import 'package:flutter/material.dart';

import 'app.dart';
import 'core/utils/shared_preferences_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferencesManager.init();

  runApp(const MainApp());
}
