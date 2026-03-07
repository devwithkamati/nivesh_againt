class AdminProfileModel {
  final int? agentId;
  final String? agentName;
  final String? mobileNumber;
  final String? emailId;
  final String? gender;
  final String? address;
  final String? city;
  final String? agentImage;
  final String? createdDate;

  AdminProfileModel({
    this.agentId,
    this.agentName,
    this.mobileNumber,
    this.emailId,
    this.gender,
    this.address,
    this.city,
    this.agentImage,
    this.createdDate,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      agentId: json['AgentId'],
      agentName: json['AgentName'],
      mobileNumber: json['MobileNumber'],
      emailId: json['EmailId'],
      gender: json['Gender'],
      address: json['Address'],
      city: json['City'],
      agentImage: json['AgentImage'],
      createdDate: json['CreatedDate'],
    );
  }
}