class Subscription {
  String id;
  String title;
  String description;
  String price;
  String rawPrice;
  String currencyCode;
  // String currencySymbol;
  bool isSelected;
  String subscriptionName;

  Subscription(
    this.id,
    this.title,
    this.description,
    this.price,
    this.rawPrice,
    this.currencyCode,
    // this.currencySymbol,
    this.isSelected,
    this.subscriptionName,
  );
}
