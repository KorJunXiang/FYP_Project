class Maintenance {
  String? maintenanceId;
  String? userId;
  String? referenceId;
  String? propertyName;
  String? tenantName;
  String? maintenanceType;
  String? maintenanceDesc;
  String? maintenanceCost;
  String? maintenanceDate;

  Maintenance(
      {this.maintenanceId,
      this.userId,
      this.referenceId,
      this.propertyName,
      this.tenantName,
      this.maintenanceType,
      this.maintenanceDesc,
      this.maintenanceCost,
      this.maintenanceDate});

  Maintenance.fromJson(Map<String, dynamic> json) {
    maintenanceId = json['maintenance_id'];
    userId = json['user_id'];
    referenceId = json['reference_id'];
    propertyName = json['property_name'];
    tenantName = json['tenant_name'];
    maintenanceType = json['maintenance_type'];
    maintenanceDesc = json['maintenance_desc'];
    maintenanceCost = json['maintenance_cost'];
    maintenanceDate = json['maintenance_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_id'] = maintenanceId;
    data['user_id'] = userId;
    data['reference_id'] = referenceId;
    data['property_name'] = propertyName;
    data['tenant_name'] = tenantName;
    data['maintenance_type'] = maintenanceType;
    data['maintenance_desc'] = maintenanceDesc;
    data['maintenance_cost'] = maintenanceCost;
    data['maintenance_date'] = maintenanceDate;
    return data;
  }
}
