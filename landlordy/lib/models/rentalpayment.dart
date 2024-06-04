class RentalPayment {
  String? paymentId;
  String? userId;
  String? propertyId;
  String? propertyName;
  String? tenantId;
  String? tenantName;
  String? paymentAmount;
  String? rentalPrice;
  String? month;
  String? year;
  String? paymentDatetime;

  RentalPayment(
      {this.paymentId,
      this.userId,
      this.propertyId,
      this.propertyName,
      this.tenantId,
      this.tenantName,
      this.paymentAmount,
      this.rentalPrice,
      this.month,
      this.year,
      this.paymentDatetime});

  RentalPayment.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    userId = json['user_id'];
    propertyId = json['property_id'];
    propertyName = json['property_name'];
    tenantId = json['tenant_id'];
    tenantName = json['tenant_name'];
    paymentAmount = json['payment_amount'];
    rentalPrice = json['rental_price'];
    month = json['month'];
    year = json['year'];
    paymentDatetime = json['payment_datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_id'] = paymentId;
    data['user_id'] = userId;
    data['property_id'] = propertyId;
    data['property_name'] = propertyName;
    data['tenant_id'] = tenantId;
    data['tenant_name'] = tenantName;
    data['payment_amount'] = paymentAmount;
    data['rental_price'] = rentalPrice;
    data['month'] = month;
    data['year'] = year;
    data['payment_datetime'] = paymentDatetime;
    return data;
  }
}
