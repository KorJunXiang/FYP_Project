class Tenant {
  String? tenantId;
  String? userId;
  String? tenantName;
  String? tenantEmail;
  String? tenantGender;
  String? tenantAge;
  String? tenantCategory;
  String? tenantPhone;
  String? latestProperty;
  String? rentalStatus;
  String? rentalPrice;

  Tenant(
      {this.tenantId,
      this.userId,
      this.tenantName,
      this.tenantEmail,
      this.tenantGender,
      this.tenantAge,
      this.tenantCategory,
      this.tenantPhone,
      this.latestProperty,
      this.rentalStatus,
      this.rentalPrice});

  Tenant.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenant_id'];
    userId = json['user_id'];
    tenantName = json['tenant_name'];
    tenantEmail = json['tenant_email'];
    tenantGender = json['tenant_gender'];
    tenantAge = json['tenant_age'];
    tenantCategory = json['tenant_category'];
    tenantPhone = json['tenant_phone'];
    latestProperty = json['latest_property'];
    rentalStatus = json['rental_status'];
    rentalPrice = json['rental_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tenant_id'] = tenantId;
    data['user_id'] = userId;
    data['tenant_name'] = tenantName;
    data['tenant_email'] = tenantEmail;
    data['tenant_gender'] = tenantGender;
    data['tenant_age'] = tenantAge;
    data['tenant_category'] = tenantCategory;
    data['tenant_phone'] = tenantPhone;
    data['latest_property'] = latestProperty;
    data['rental_status'] = rentalStatus;
    data['rental_price'] = rentalPrice;
    return data;
  }
}
