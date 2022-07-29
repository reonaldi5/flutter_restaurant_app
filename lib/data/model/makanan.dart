class Makanan{
  final String name;

  Makanan({required this.name});
  factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(name: json['name']);
}