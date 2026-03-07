class LoginResponse {

  final bool status;
  final String message;
  final AgentData? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] != null
          ? AgentData.fromJson(json["Data"])
          : null,
    );
  }
}

class AgentData {

  final int agentId;
  final String agentName;
  final String mobileNumber;
  final String emailId;

  AgentData({
    required this.agentId,
    required this.agentName,
    required this.mobileNumber,
    required this.emailId,
  });

  factory AgentData.fromJson(Map<String, dynamic> json) {
    return AgentData(
      agentId: json["AgentId"],
      agentName: json["AgentName"],
      mobileNumber: json["MobileNumber"],
      emailId: json["EmailId"],
    );
  }
}