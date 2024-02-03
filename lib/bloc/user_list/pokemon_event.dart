part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class GetPokemonList extends PokemonEvent {
  final int pageKey;

  const GetPokemonList({
    required this.pageKey,
  });

  @override
  List<Object?> get props => [pageKey];
}
