class Order {
  final String customerUid;
  final String productId;
  final String productName;
  final DateTime purchaseDate;
  final String? downloadUrl;
  Order({
    required this.customerUid,
    required this.productId,
    required this.productName,
    required this.purchaseDate,
    this.downloadUrl
  });

  Order.fromJson(Map<String, dynamic> object)
      : customerUid = object['customerUid'],
        productId = object['productId'],
        productName = object['productName'],
        purchaseDate = object['purchaseDate'],
        downloadUrl = object['downloadUrl'];

  Map<String, dynamic> toJson() => {
        'customerUid': customerUid,
        'productId': productId,
        'productName': productName,
        'purchaseDate': purchaseDate,
        'downloadUrl': downloadUrl ?? '',
      };
}
