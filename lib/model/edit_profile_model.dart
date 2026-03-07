class EditProfileModel {
  int? agentId;
  String? agentName;
  String? mobileNumber;
  String? emailId;
  String? gender;
  String? city;
  String? address;
  String? agentImage;

  EditProfileModel({
    this.agentId,
    this.agentName,
    this.mobileNumber,
    this.emailId,
    this.gender,
    this.city,
    this.address,
    this.agentImage,
  });

  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      agentId: json['AgentId'],
      agentName: json['AgentName'],
      mobileNumber: json['MobileNumber'],
      emailId: json['EmailId'],
      gender: json['Gender'],
      city: json['City'],
      address: json['Address'],
      agentImage: json['AgentImage'],
    );
  }
}