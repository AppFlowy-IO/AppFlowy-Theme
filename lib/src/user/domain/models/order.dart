class Order {
  final String customerUid;
  final String productId;
  final String productName;
  final DateTime purchaseDate;
  Order({
    required this.customerUid,
    required this.productId,
    required this.productName,
    required this.purchaseDate,
  });

  Order.fromJson(Map<String, dynamic> object)
      : customerUid = object['customerUid'] ?? 'undefined',
        productId = object['productId'] ?? 'undefined',
        productName = object['productName'] ?? 'undefined',
        purchaseDate = object['purchaseDate]'] ?? 'undefined';

  Map<String, dynamic> toJson() => {
        'customerUid': customerUid,
        'productId': productId,
        'productName': productName,
        'purchaseDate': purchaseDate,
      };
}
