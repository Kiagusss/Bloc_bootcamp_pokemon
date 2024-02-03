part of 'pokemon_bloc.dart';



abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final AllPokemon pokemonList;

  const PokemonLoaded({
    required this.pokemonList,
  });

  @override
  List<Object?> get props => [pokemonList];
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}