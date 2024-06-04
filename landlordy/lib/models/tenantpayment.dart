class TenantPayment {
  String? tenantName;
  String? monthYear;
  String? paymentAmount;

  TenantPayment({
    required this.tenantName,
    required this.monthYear,
    required this.paymentAmount,
  });

  TenantPayment.fromJson(Map<String, dynamic> json) {
    tenantName = json['tenant_name'];
    monthYear = "${json['month']} ${json['year']}";
    paymentAmount = json['payment_amount'];
  }

  @override
  String toString() {
    return 'Tenant Name: $tenantName, Month Year: $monthYear, Payment Amount: $paymentAmount';
  }
}
