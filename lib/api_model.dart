import 'dart:convert';

class Pokemon {
  final String name;
  final int id;
  final int baseExperience;
  final int height;
  final int weight;
  final List<Map<String, dynamic>> abilities;
  final List<Map<String, dynamic>> moves;
  final List<Map<String, dynamic>> types;
  final String frontImageUrl;
  final List<Map<String, dynamic>> stats;

  Pokemon({
    required this.name,
    required this.id,
    required this.baseExperience,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.moves,
    required this.types,
    required this.frontImageUrl,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      baseExperience: json['base_experience'],
      height: json['height'],
      weight: json['weight'],
      abilities: List<Map<String, dynamic>>.from(json['abilities']),
      moves: List<Map<String, dynamic>>.from(json['moves']),
      types: List<Map<String, dynamic>>.from(json['types']),
      frontImageUrl: json['sprites']['front_default'],
      stats: List<Map<String, dynamic>>.from(json['stats']),
    );
  }
}

