class Property {
  String? propertyId;
  String? userId;
  String? propertyName;
  String? propertyAddress;
  String? propertyState;
  String? propertyType;
  String? rentalPrice;
  String? propertyStatus;
  String? imageNum;
  String? tenantId;
  String? currentTenant;
  String? propertyDatereg;

  Property(
      {this.propertyId,
      this.userId,
      this.propertyName,
      this.propertyAddress,
      this.propertyState,
      this.propertyType,
      this.rentalPrice,
      this.propertyStatus,
      this.imageNum,
      this.tenantId,
      this.currentTenant,
      this.propertyDatereg});

  Property.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    userId = json['user_id'];
    propertyName = json['property_name'];
    propertyAddress = json['property_address'];
    propertyState = json['property_state'];
    propertyType = json['property_type'];
    rentalPrice = json['rental_price'];
    propertyStatus = json['property_status'];
    imageNum = json['image_num'];
    tenantId = json['tenant_id'];
    currentTenant = json['current_tenant'];
    propertyDatereg = json['property_datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['property_id'] = propertyId;
    data['user_id'] = userId;
    data['property_name'] = propertyName;
    data['property_address'] = propertyAddress;
    data['property_state'] = propertyState;
    data['property_type'] = propertyType;
    data['rental_price'] = rentalPrice;
    data['property_status'] = propertyStatus;
    data['image_num'] = imageNum;
    data['tenant_id'] = tenantId;
    data['current_tenant'] = currentTenant;
    data['property_datereg'] = propertyDatereg;
    return data;
  }
}
