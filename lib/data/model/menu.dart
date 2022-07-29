import 'minuman.dart';
import 'makanan.dart';

class Menu {
  final List<Makanan> foods;
  final List<Minuman> drinks;

  Menu({required this.foods, required this.drinks});

  factory Menu.fromJson(Map<String, dynamic> json) {
    final List<Makanan> foods = (json['foods'] as List)
        .map((foodJson) => Makanan.fromJson(foodJson))
        .toList();

    final List<Minuman> drinks = (json['drinks'] as List)
        .map((drinkJson) => Minuman.fromJson(drinkJson))
        .toList();

    return Menu(foods: foods, drinks: drinks);
  }
}
