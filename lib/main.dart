import 'package:e_comm/add_products_screen.dart';
import 'package:e_comm/home_screen.dart';
import 'package:e_comm/login_screen.dart';
import 'package:e_comm/products_screen.dart';
import 'package:e_comm/profile_screen.dart';
import 'package:e_comm/register_screen.dart';
import 'package:e_comm/splash_screen.dart';
import 'package:e_comm/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      title: "E-commerce",
      theme: Themes.myThemes,
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      showPerformanceOverlay: false,
      initialRoute: 'splash_page',
      routes: {
        'splash_page': (context) => const SplashPage(),
        'home_page': (context) => const HomePage(),
        'login_page': (context) => const LoginPage(),
        'register_page': (context) => const RegisterPage(),
        'profile_page': (context) => const ProfilePage(),
        'addProducts_page': (context) => const AddProductsPage(),
      },
    ),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}
