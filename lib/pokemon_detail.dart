import 'package:coba_api_flutter/api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class PokemonDetailApi extends StatefulWidget {
  String? url;
  PokemonDetailApi({super.key, required this.url});

  @override
  State<PokemonDetailApi> createState() => _PokemonDetailApiState();
}
Dio _dio = Dio();

Future<PokemonDetail> getPokedata(String url) async {
  try {
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = response.data;

   
      final PokemonDetail pokemon = PokemonDetail.fromJson(data);

      return pokemon;
    } else {
      throw Exception('Error occurred: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    // You can throw or return a default Pokemon object here based on your requirement
    throw Exception('Failed to fetch Pokemon data');
  }
}




class _PokemonDetailApiState extends State<PokemonDetailApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(future: getPokedata(widget.url ?? 'https://pokeapi.co/api/v2/pokemon/1/'), builder:(context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            final PokemonDetail? data = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data!.name ?? 'alamat alamat'),
                Text(data.height.toString()),
                Text(data.weight.toString()),
              ],
            );
          }
        },),
      ),
    );
  }
}