class PropertyTenant {
  String? propertyName;
  String? currentTenant;

  PropertyTenant({this.propertyName, this.currentTenant});

  PropertyTenant.fromJson(Map<String, dynamic> json) {
    propertyName = json['property_name'];
    currentTenant = json['current_tenant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['property_name'] = propertyName;
    data['current_tenant'] = currentTenant;
    return data;
  }

  @override
  String toString() {
    return 'PropertyTenant(propertyName: $propertyName, currentTenant: $currentTenant)';
  }
}
