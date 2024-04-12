class Store {
  Store({
    required this.storeName,
    required this.storeAddress,
    required this.storePhoneNumber,
    required this.storeURL,
    required this.latitude,
    required this.longitude,
  });

  final String storeName;

  final double latitude;
  final double longitude;
  final String storeAddress;
  final String storePhoneNumber;
  final String storeURL;

  Map<String, dynamic> toJson() {
    return {
      "storeName": storeName,
      "storeAddress": storeAddress,
      "storePhoneNumber": storePhoneNumber,
      "storeURL": storeURL,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  factory Store.fromJson(Map<dynamic, dynamic> json) {
    return Store(
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
      storePhoneNumber: json['storePhoneNumber'],
      storeURL: json['storeURL'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
