class SaveStore {
  SaveStore({
    required this.storeName,
    required this.storeAddress,
    required this.storePhoneNumber,
    required this.storeURL,
  });

  final String storeName;

  final String storeAddress;
  final String storePhoneNumber;
  final String storeURL;

  Map<String, dynamic> toJson() {
    return {
      "storeName": storeName,
      "storeAddress": storeAddress,
      "storePhoneNumber": storePhoneNumber,
      "storeURL": storeURL,
    };
  }

  factory SaveStore.fromJson(Map<dynamic, dynamic> json) {
    return SaveStore(
      storeName: json['storeName'],
      storeAddress: json['storeAddress'],
      storePhoneNumber: json['storePhoneNumber'],
      storeURL: json['storeURL'],
    );
  }
}
