class PropertyModel {
  final int propertyId;
  final String title;
  final String location;
  final double price;
  final String status;
  final String phone;
  final String createdDate;
  final String? propertyImage;

  PropertyModel(
      {required this.propertyId,
      required this.title,
      required this.location,
      required this.price,
      required this.status,
      required this.phone,
      required this.createdDate,
      required this.propertyImage});

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      propertyId: json['PropertyId'] ?? 0,
      title: json['PropertyTitle'] ?? '',
      location: "${json['City']}, ${json['State']}",
      price: (json['Price'] ?? 0).toDouble(),
      status: json['Status'] ?? '',
      phone: json['Phone'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
      propertyImage: json['PropertyImage'] ?? '',
    );
  }
}
