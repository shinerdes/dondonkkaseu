import 'package:dondonkkaseu/components/rounded_asset_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class SavedStoreContainer extends StatefulWidget {
  SavedStoreContainer({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.url,
  });

  String name;
  String address;
  String phone;
  String url;
  @override
  State<SavedStoreContainer> createState() => SavedStoreContainerState();
}

class SavedStoreContainerState extends State<SavedStoreContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.store,
                size: 35,
              ),
              const SizedBox(width: 5.0),
              Text(
                widget.name,
                style: const TextStyle(color: Colors.black, fontSize: 20),
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
                widget.phone,
                style: const TextStyle(color: Colors.black, fontSize: 20),
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
                  child: Text(
                    widget.address,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 100,
            width: 150,
            child: AssetRoundedButton(
              title: 'Maps',
              colour: Colors.lightGreen,
              icon: 'assets/images/naver_map_icon.png',
              onPressed: () {
                launchUrl(Uri.parse(
                  widget.url,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
