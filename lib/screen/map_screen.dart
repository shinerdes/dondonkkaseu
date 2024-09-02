import 'dart:async';
import 'dart:developer';

import 'package:dondonkkaseu/model/store_model.dart';
import 'package:dondonkkaseu/screen/dialog_screen.dart';
import 'package:dondonkkaseu/screen/login_screen.dart';
import 'package:dondonkkaseu/screen/saved_store_screen.dart';
import 'package:dondonkkaseu/screen/upload_store_screen.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map_screen';
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<NMarker> markerList = {};

  @override
  void initState() {
    super.initState();
  }

  // var marker = NMarker(
  //   id: 'test1',
  //   position: const NLatLng(37.3558206, 127.1034001),
  //   icon: const NOverlayImage.fromAssetImage('assets/images/dondon.png'),
  // );

  // var marker2 = NMarker(
  //   id: 'test2',
  //   position: const NLatLng(37.5554166, 126.924535),
  //   icon: const NOverlayImage.fromAssetImage('assets/images/dondon.png'),
  // );

  @override
  Widget build(BuildContext context) {
    final Completer<NaverMapController> mapControllerCompleter = Completer();

    return FutureBuilder(
        future: readStore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            markerList.addAll(snapshot.data!);
            return Scaffold(
              body: SafeArea(
                child: Stack(
                  children: <Widget>[
                    NaverMap(
                      options: const NaverMapViewOptions(
                        indoorEnable: true, // 실내 맵 사용 가능 여부 설정
                        locationButtonEnable: true, // 위치 버튼 표시 여부 설정
                        consumeSymbolTapEvents: true,
                        zoomGesturesEnable: true, // 심볼 탭 이벤트 소비 여부 설정
                        nightModeEnable: false,
                        scaleBarEnable: true,

                        minZoom: 5, // default is 0
                        maxZoom: 13, // default is 21
                      ),
                      onMapReady: (controller) async {
                        // 지도 준비 완료 시 호출되는 콜백 함수
                        mapControllerCompleter.complete(
                            controller); // Completer에 지도 컨트롤러 완료 신호 전송
                        log("onMapReady", name: "onMapReady");

                        controller.addOverlayAll({
                          for (int i = 0; i < markerList.length; i++)
                            markerList.elementAt(i)
                        });

                        for (int i = 0; i < markerList.length; i++) {
                          markerList.elementAt(i).setOnTapListener(
                                (overlay) => {
                                  showDialog(
                                      context: context,
                                      builder: (_) {
                                        return DialogScreen(
                                            id: overlay.info.id);
                                      })
                                },
                              );
                        }
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(24),
                        width: 64,
                        height: 250,
                        color: const Color.fromRGBO(0, 0, 0, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 64,
                                height: 64,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SavedStoreScreen()))
                                        .then((value) {});
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.zero),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.lightGreen),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.store_outlined,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                width: 64,
                                height: 64,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showdialog(context);
                                  },
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.zero),
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            Colors.lightGreen),
                                    shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.logout_outlined,
                                    size: 40.0,
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 20.0),
                              // Container(
                              //   height: 64.0,
                              //   width: 64.0,
                              //   color: Colors.blue,
                              //   child: TextButton(
                              //     onPressed: () {
                              //       Navigator.push(
                              //               context,
                              //               MaterialPageRoute(
                              //                   builder: (context) =>
                              //                       const UploadStoreScrren()))
                              //           .then((value) {});
                              //     },
                              //     child: const Text(
                              //       'data',
                              //       style: TextStyle(color: Colors.amber),
                              //     ),
                              //   ),
                              // ),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

myDialog(context, NMarker overlay) {
  showDialog(
    context: context,
    builder: (context) {
      return Builder(builder: (context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 35.0,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    readStoreInfo(overlay.info.id);
                  },
                  child: const Text(
                    'async',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    },
  );
}

Future<Store> readStoreInfo(String id) async {
  Store st;
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('store').child(id).get();

  Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;

  st = Store(
      storeName: toMap['storeName'],
      storeAddress: toMap['storeAddress'],
      storePhoneNumber: toMap['storePhoneNumber'],
      storeURL: toMap['storeURL'],
      latitude: toMap['latitude'],
      longitude: toMap['longitude']);

  return st;
}

Future<Set<NMarker>> readStore() async {
  Set<NMarker> markerList = {};
  final ref = FirebaseDatabase.instance.ref();
  final snapshot = await ref.child('store').get();

  Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;
  List onlyKey = toMap.keys.toList();

  for (int i = 0; i < snapshot.children.length; i++) {
    var snapshot2 = await ref.child('store').child(onlyKey[i]).get();

    Map<dynamic, dynamic> toMap2 = snapshot2.value as Map<dynamic, dynamic>;

    markerList.add(NMarker(
      id: onlyKey[i], // uid
      position: NLatLng(toMap2['latitude'], toMap2['longitude']),
      size: const Size(50, 50),
      icon: const NOverlayImage.fromAssetImage('assets/images/dondon.png'),
    ));
  }

  return markerList;
}

Future<dynamic> _showdialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('로그아웃'),
      content: const Text('로그아웃 하시겠습니까?'),
      actions: [
        ElevatedButton(
            onPressed: () {
              _signOut();
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
            child: const Text('로그아웃')),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소')),
      ],
    ),
  );
}

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
}
