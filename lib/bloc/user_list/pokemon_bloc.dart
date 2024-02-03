import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:coba_api_flutter/all_pokemon_api.dart';
import 'package:coba_api_flutter/api_provider.dart';

import 'package:equatable/equatable.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final ApiService apiService;

  PokemonBloc({
    required this.apiService,
  }) : super(PokemonInitial()) {
    on<GetPokemonList>((event, emit) async {
      try {
        emit(PokemonLoading());
        final pokemonList = await apiService.getAllPokemon(event.pageKey);
        emit(PokemonLoaded(pokemonList: pokemonList));
      } catch (error) {
        emit(PokemonError(message: 'Error fetching Pokemon list: $error'));
      }
    });
  }

  Future<void> searchPokemon(String query) async {
    // Implement search logic here
  }
}
