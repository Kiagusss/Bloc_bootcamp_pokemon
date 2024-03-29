import 'package:coba_api_flutter/all_pokemon_api.dart';
import 'package:dio/dio.dart';

class AppService {

  final Dio _dio = Dio();

  final String baseUrl = "https://pokeapi.co/api/v2/pokemon";

  Future<PokemonListResponse> fetchPokemonList(int page, int limit) async {
    final response =  await _dio.get("$baseUrl?offset=$page&limit=$limit");

    if (response.statusCode != 200) {
      throw Exception(response.data['errorMessage']);
    }

    return PokemonListResponse.fromJson(response.data);
  }
}