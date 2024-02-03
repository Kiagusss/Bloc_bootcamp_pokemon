import 'package:coba_api_flutter/api_provider.dart';
import 'package:coba_api_flutter/bloc/user_list/pokemon_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPokemonApi extends StatelessWidget {
  const AllPokemonApi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonBloc(apiService: ApiService()),
      child: _AllPokemonApiView(),
    );
  }
}

class _AllPokemonApiView extends StatefulWidget {
  @override
  _AllPokemonApiViewState createState() => _AllPokemonApiViewState();
}

class _AllPokemonApiViewState extends State<_AllPokemonApiView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "20";

  @override
  void initState() {
    super.initState();
    context.read<PokemonBloc>().add(const GetPokemonList(pageKey: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.network(
          "https://1000logos.net/wp-content/uploads/2017/05/Pokemon-Logo.png",
          height: 100,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Show: ',
                style: TextStyle(color: Colors.blue),
              ),
              DropdownButton<String>(
                value: _selectedFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                    _selectedFilter == "20"
                        ? context
                            .read<PokemonBloc>()
                            .add(const GetPokemonList(pageKey: 20))
                        : _selectedFilter == "10"
                            ? context
                                .read<PokemonBloc>()
                                .add(const GetPokemonList(pageKey: 10))
                            : _selectedFilter == "50"
                                ? context
                                    .read<PokemonBloc>()
                                    .add(const GetPokemonList(pageKey: 50))
                                : _selectedFilter == "100"
                                    ? context
                                        .read<PokemonBloc>()
                                        .add(const GetPokemonList(pageKey: 100))
                                    : _selectedFilter;
                  });
                },
                items: <String>['10', '20', '50', '100']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<PokemonBloc, PokemonState>(
              builder: (context, state) {
                if (state is PokemonLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PokemonLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.pokemonList.results!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Card(
                          color: Colors.yellow,
                          shadowColor: Colors.black,
                          child: ListTile(
                            trailing:
                                const Icon(Icons.keyboard_arrow_right_rounded),
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                "https://img.pokemondb.net/sprites/sword-shield/icon/${state.pokemonList.results![index].name!}.png",
                              ),
                            ),
                            title:
                                Text(state.pokemonList.results![index].name!),
                            subtitle: const Text("INI DETAIL NYA YAA"),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is PokemonError) {
                  return Text('Error: ${state.message}');
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
