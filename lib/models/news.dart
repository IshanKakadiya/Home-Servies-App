// ignore_for_file: non_constant_identifier_names

class News {
  int? id;
  String News_title;
  String Description;
  String Image;
  String News_Date;
  String News_Time;
  bool Is_Active;

  News({
    this.id,
    required this.News_title,
    required this.Description,
    required this.Image,
    required this.News_Date,
    required this.News_Time,
    required this.Is_Active,
  });

  factory News.fromMap({required Map<String, dynamic> data}) {
    return News(
      id: data["id"],
      Description: data["Description"],
      News_title: data["News_title"],
      Image: data["Image"],
      News_Date: data["News_Date"],
      News_Time: data["News_Time"],
      Is_Active: data["Is_Active"],
    );
  }
}
