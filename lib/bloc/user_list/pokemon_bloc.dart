import 'package:coba_api_flutter/bloc/user_list/pokemon_event.dart';
import 'package:coba_api_flutter/bloc/user_list/pokemon_state.dart';
import 'package:coba_api_flutter/repositories/app_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final AppRepository repository;

  static const int _pageLimit = 20;

  PokemonListBloc({
    required this.repository,
  }) : super(PokemonListLoading()) {

    on<GetPokemonList>((event, emit) async {
      try {
        //await Future.delayed(const Duration(seconds: 5));
        emit(PokemonListLoading());
        final data = await repository.getContentPokemonList(
          event.pageKey,
          false,
          _pageLimit,
        );
        final isLastPage = data.isLastPage;
        if (isLastPage!) {
          emit(PokemonListLastPageLoaded(data: data));
        } else {
          final nextPageKey = event.pageKey + 1;
          emit(PokemonListLoaded(data: data, nextPageKey: nextPageKey));
        }
      } on Exception catch (e, stackTrace) {
        debugPrint(stackTrace.toString());
        emit(PokemonListError(code: 100, message: "Error Gua Nggak Tau Dimana! - KOMPUTER ANDA!"));
      } catch (e, stackTrace) {
        debugPrint(stackTrace.toString());
      }
    });
  }
}