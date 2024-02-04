import 'package:coba_api_flutter/all_pokemon_api.dart';
import 'package:coba_api_flutter/data/app_service.dart';
import 'package:coba_api_flutter/data/local_service.dart';

class AppRepository {
  final AppService appService;
  final LocalService localService;

  AppRepository({
    required this.appService,
    required this.localService,
  });

  Future<PokemonList> getContentPokemonList(
      int page, bool isProcess, int limit) async {
    PokemonListResponse response =
        await appService.fetchPokemonList(page, limit);
    return PokemonList(
      isLastPage: response.count! < limit,
      pokemons: response.pokemon!
          .map((data) => Pokemon(
                name: data.name,
                url: data.url,
              ))
          .toList(),
    );
  }
}
