// ignore_for_file: non_constant_identifier_names

class Promocode {
  int? id;
  String code;
  num discount;
  num stock;
  bool is_Active;

  Promocode({
    this.id,
    required this.code,
    required this.discount,
    required this.stock,
    required this.is_Active,
  });

  factory Promocode.fromMap({required Map<String, dynamic> data}) {
    return Promocode(
      id: data["id"],
      code: data["code"] ?? "",
      discount: data["discount"] ?? 0,
      stock: data["stock"] ?? 0,
      is_Active: data["Is_Active"] ?? false,
    );
  }
}
