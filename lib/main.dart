import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'constants/app_constants.dart';
import 'feature/home/presentation/home_screen.dart';
import 'feature/login/presentation/login_screen.dart';
import 'helpers/firebase_options.dart';
import 'service/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = GetStorage();
  @override
  void initState() {
    storage.writeIfNull(AppConstants.kKeyIsLoggedIn, false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoogin = storage.read(AppConstants.kKeyIsLoggedIn);
    return MaterialApp(
        title: 'Selise Demo App',
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: isLoogin ? const MyHomePage() : const LoginScreen());
  }
}
