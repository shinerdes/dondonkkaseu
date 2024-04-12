import 'package:dondonkkaseu/components/rounded_asset_button.dart';
import 'package:dondonkkaseu/model/store_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DialogScreen extends StatefulWidget {
  late String id;
  DialogScreen({super.key, required this.id});

  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  bool storeStar = false;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([readData(widget.id), readStar(widget.id)]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Store snapStore = snapshot.data![0];

            storeStar = snapshot.data![1] as bool;

            return AlertDialog(
              content: Container(
                padding: const EdgeInsets.all(0.0),
                width: 280,
                height: 280,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if (storeStar == true) {
                                      await FirebaseDatabase.instance
                                          .ref()
                                          .child('users')
                                          .child(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .child('saved')
                                          .child(widget.id)
                                          .remove();

                                      setState(() {
                                        storeStar = false;
                                      });

                                      //1
                                    } else {
                                      FirebaseDatabase.instance
                                          .ref()
                                          .child('users')
                                          .child(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .child('saved')
                                          .child(widget.id)
                                          .set({
                                        "storeName": snapStore.storeName,
                                        "storeAddress": snapStore.storeAddress,
                                        "storePhoneNumber":
                                            snapStore.storePhoneNumber,
                                        "storeURL": snapStore.storeURL,
                                      });

                                      setState(() {
                                        storeStar = true;
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.star,
                                    size: 50.0,
                                    color:
                                        storeStar ? Colors.blue : Colors.white,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 50.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 35,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          snapStore.storeName,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 35,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          snapStore.storePhoneNumber,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.place,
                            size: 35,
                          ),
                          const SizedBox(width: 5.0),
                          Expanded(
                            child: Text(snapStore.storeAddress,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400,
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: SizedBox(
                            height: 100,
                            width: 150,
                            child: AssetRoundedButton(
                              title: 'Maps',
                              colour: Colors.lightGreen,
                              icon: 'assets/images/naver_map_icon.png',
                              onPressed: () {
                                launchUrl(Uri.parse(
                                  snapStore.storeURL,
                                ));
                              },
                            ),
                          ),
                        ))
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

Future<dynamic> readData(String id) async {
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

Future<dynamic> readStar(String id) async {
  bool result;

  final exist = await FirebaseDatabase.instance
      .ref()
      .child('users')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('saved')
      .child(id)
      .get();

  result = exist.exists;

  return result;
}
