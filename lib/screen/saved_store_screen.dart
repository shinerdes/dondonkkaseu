import 'package:dondonkkaseu/model/saved_store.model.dart';

import 'package:dondonkkaseu/screen/saved_store_container.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SavedStoreScreen extends StatefulWidget {
  static const String id = 'saved_store_screen';
  const SavedStoreScreen({super.key});

  @override
  State<SavedStoreScreen> createState() => _SavedStoreScreenState();
}

class _SavedStoreScreenState extends State<SavedStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          _onBackPressed(context);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(''),
          ),
          body: FutureBuilder(
            future: readData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data!.length);
                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SavedStoreContainer(
                        name: snapshot.data![index].storeName,
                        address: snapshot.data![index].storeAddress,
                        phone: snapshot.data![index].storePhoneNumber,
                        url: snapshot.data![index].storeURL);
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}

Future<List<SaveStore>> readData() async {
  final snapshot = await FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('saved')
      .get();

  if (snapshot.exists) {
    Map<dynamic, dynamic> toMap = snapshot.value as Map<dynamic, dynamic>;

    List<SaveStore> data =
        toMap.values.map((e) => SaveStore.fromJson(e)).toList();

    return data;
  } else {
    return List.empty();
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  Navigator.pop(context, false);
  return true;
}
