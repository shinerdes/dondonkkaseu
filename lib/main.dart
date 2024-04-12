/*


1. NAVER MAPS API
  - mainView navermap 
  - marker test
  - 
2. FIREBASE DATABASE
  -
3. NAVER MAPS STORE URL Link
4. save store
  - coredata or firebase

*/

import 'dart:async';
import 'dart:developer';

import 'package:dondonkkaseu/firebase_options.dart';
import 'package:dondonkkaseu/screen/login_screen.dart';
import 'package:dondonkkaseu/screen/map_screen.dart';
import 'package:dondonkkaseu/screen/saved_store_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

Future<void> main() async {
  await _initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// 지도 초기화하기
Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'cltzfl0r18', // 클라이언트 ID 설정
      onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed"));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => const LoginScreen(),
        MapScreen.id: (context) => const MapScreen(),
        SavedStoreScreen.id: (context) => const SavedStoreScreen(),
      },
    );
  }
}
