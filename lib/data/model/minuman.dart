class Minuman{
  final String name;
  Minuman({required this.name});

  factory Minuman.fromJson(Map<String, dynamic> json) => Minuman(name: json['name']);
}