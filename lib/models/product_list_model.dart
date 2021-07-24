class ProductListModel {
  late List<dynamic> productList;

  ProductListModel({
    required this.productList,
  });

  ProductListModel.fromData(Map<String, dynamic> data)
      : productList = data['productList'] ?? [];

  Map<String, dynamic> toJson() {
    return {
      'productList': productList,
    };
  }
}
