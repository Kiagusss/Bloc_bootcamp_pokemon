import 'package:coba_api_flutter/all_pokemon_api.dart';
import 'package:coba_api_flutter/api_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Pokemon> getPokemon(String pokemonName) async {
    try {
      final response =
          await _dio.get('https://pokeapi.co/api/v2/pokemon/$pokemonName');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return Pokemon.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<AllPokemon> getAllPokemon(int limit) async {
    try {
      final response =
          await _dio.get('https://pokeapi.co/api/v2/pokemon?limit=$limit');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return AllPokemon.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Pokemon>> searchPokemon(String query) async {
    try {
      final response =
          await _dio.get('https://pokeapi.co/api/v2/pokemon/$query');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['results'];
        return List<Pokemon>.from(data.map((x) => Pokemon.fromJson(x)));
      } else {
        throw Exception('Failed to search Pokemon');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
}
