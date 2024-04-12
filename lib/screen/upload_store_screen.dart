// upload

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class UploadStoreScrren extends StatefulWidget {
  const UploadStoreScrren({super.key});

  @override
  State<UploadStoreScrren> createState() => _UploadStoreScrrenState();
}

// upload store info
// not able
class _UploadStoreScrrenState extends State<UploadStoreScrren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              var uuid = const Uuid();
              var storeUuid = uuid.v1();

              // 데이터 넣기
              FirebaseDatabase.instance
                  .ref()
                  .child('store')
                  .child(storeUuid)
                  .set({
                "storeName": "모스키친 신대방삼거리",
                "latitude": 37.4974983,
                "longitude": 126.9276573,
                "storeAddress": "서울 동작구 보라매로 91 1층",
                "storePhoneNumber": "0507-1307-3529",
                "storeURL": "https://naver.me/5JJQDIz0",
              });
            },
            child: const Text('asdasd')),
      ),
    );
  }
}
