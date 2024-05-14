class PropertyTenant {
  String? propertyId;
  String? propertyName;
  String? currentTenant;
  String? tenantId;

  PropertyTenant(
      {this.propertyId, this.propertyName, this.tenantId, this.currentTenant});

  PropertyTenant.fromJson(Map<String, dynamic> json) {
    propertyId = json['property_id'];
    propertyName = json['property_name'];
    tenantId = json['tenant_id'];
    currentTenant = json['current_tenant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['property_id'] = propertyId;
    data['property_name'] = propertyName;
    data['tenant_id'] = tenantId;
    data['current_tenant'] = currentTenant;
    return data;
  }

  @override
  String toString() {
    return 'PropertyTenant(property ID: $propertyId, propertyName: $propertyName, tenant ID: $tenantId, currentTenant: $currentTenant)';
  }
}
