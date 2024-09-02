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
                "storeName": "카츠야",
                "latitude": 37.543066,
                "longitude": 126.971812,
                "storeAddress": "서울 용산구 한강대로81길 10 카츠야",
                "storePhoneNumber": "010-7269-8627",
                "storeURL": "https://naver.me/5izZuQRA",
              });
            },
            child: const Text('asdasd')),
      ),
    );
  }
}
