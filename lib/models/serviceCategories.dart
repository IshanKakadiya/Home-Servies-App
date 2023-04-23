class ServiceCategories {
  int? id;
  String name;
  String imageURL;

  ServiceCategories({this.id, required this.name, required this.imageURL});

  factory ServiceCategories.fromMap({required Map<String, dynamic> data}) {
    return ServiceCategories(
      id: data['id'],
      name: data['name'] ?? "",
      imageURL: data['imageURL'],
    );
  }
}

// List<ServiceCategories> allServiceCategoriesList = [
// ServiceCategories(name: "Cleaning", imageURL: "assets/images/cleaning.png"),
// ServiceCategories(name: "Painting", imageURL: "assets/images/painting.png"),
// ServiceCategories(name: "Repairing", imageURL: "assets/images/repairing.png"),
// ServiceCategories(
//     name: "Carpentering", imageURL: "assets/images/carpentering.png"),
// ];
