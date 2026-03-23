class LeadModel {
  final int leadId;
  final String name;
  final String mobile;
  final String email;
  final String status;
  final double propertyPrice;
  final String propertyImage;
  final String propertyLocation;
  final double userBudget;
  final String createdDate;

  LeadModel({
    required this.leadId,
    required this.name,
    required this.mobile,
    required this.email,
    required this.status,
    required this.propertyPrice,
    required this.propertyImage,
    required this.propertyLocation,
    required this.userBudget,
    required this.createdDate,
  });

  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      leadId: json['LeadId'] ?? 0,
      name: json['Name'] ?? '',
      mobile: json['Mobile'] ?? '',
      email: json['Email'] ?? '',
      status: json['Status'] ?? '',
      propertyPrice: (json['PropertyPrice'] ?? 0).toDouble(),
      propertyImage: json['PropertyImage'] ?? '',
      propertyLocation: json['PropertyLocation'] ?? '',
      userBudget: (json['UserBudget'] ?? 0).toDouble(),
      createdDate: json['CreatedDate'] ?? '',
    );
  }
}
