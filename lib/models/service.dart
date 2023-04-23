class Service {
  int? id;
  String serviceName;
  String serviceCategoriesName;
  String imageURL;
  int pricePerHour;
  int totalMinute;

  Service({
    this.id,
    required this.serviceName,
    required this.serviceCategoriesName,
    required this.imageURL,
    required this.pricePerHour,
    required this.totalMinute,
  });

  factory Service.fromMap({required Map<String, dynamic> data}) {
    return Service(
      id: data['id'],
      serviceName: data['serviceName'] ?? "",
      serviceCategoriesName: data['serviceCategoriesName'] ?? "",
      imageURL: data['imageURL'] ?? "",
      pricePerHour: data['pricePerHour'] ?? "",
      totalMinute: data['totalMinute'] ?? 60,
    );
  }
}
