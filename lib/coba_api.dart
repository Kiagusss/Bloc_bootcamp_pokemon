// import 'package:coba_api_flutter/api_model.dart';
// import 'package:flutter/material.dart';

// import 'package:dio/dio.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// class ApiService {
//   final Dio _dio = Dio();
//   final String baseUrl;

//   ApiService(this.baseUrl);

//   Future<List<Siswa>> getPosts(
//       {required int pageKey, required int pageSize}) async {
//     try {
//       final response =
//           await _dio.get("$baseUrl?page=$pageKey&per_page=$pageSize");

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = response.data;
//         return List<Siswa>.from(data["data"].map((x) => Siswa.fromJson(x)));
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }

// late List<Siswa> allProfiles;
// late List<Siswa> displayedProfiles;
// String selectedSorting = 'Nama (A-Z)';

// class FourthDayBootcamp extends StatefulWidget {
//   const FourthDayBootcamp({super.key});

//   @override
//   State<FourthDayBootcamp> createState() => _FourthDayBootcampState();
// }

// class _FourthDayBootcampState extends State<FourthDayBootcamp> {
//   static const _pageSize = 5;

//   final PagingController<int, Siswa> _pagingController =
//       PagingController(firstPageKey: 1);

//   final ApiService apiService = ApiService('https://reqres.in/api/users');

//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       final newItems =
//           await apiService.getPosts(pageKey: pageKey, pageSize: _pageSize);
//       final isLastPage = newItems.length < _pageSize;
//       if (isLastPage) {
//         _pagingController.appendLastPage(newItems);
//       } else {
//         int nextPageKey = pageKey + 1;
//         _pagingController.appendPage(newItems, nextPageKey);
//       }
//     } catch (error) {
//       _pagingController.error = error;
//     }
//   }

//   void filterProfiles(String query) {
//     List<Siswa> filteredProfiles = allProfiles
//         .where((profile) =>
//             profile.firstName!.toLowerCase().contains(query.toLowerCase()) ||
//             profile.lastName!.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//     setState(() {
//       displayedProfiles = filteredProfiles;
//     });
//   }

//   void sortProfiles() {
//     setState(() {
//       if (selectedSorting == 'Nama (A-Z)') {
//         displayedProfiles.sort((a, b) => (a.firstName ?? "")
//             .toLowerCase()
//             .compareTo((b.firstName ?? "").toLowerCase()));
//       } else if (selectedSorting == 'Nama (Z-A)') {
//         displayedProfiles.sort((a, b) => (b.firstName ?? "")
//             .toLowerCase()
//             .compareTo((a.firstName ?? "").toLowerCase()));
//       }
//     });
//   }

//   @override
//   void initState() {
//     _pagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey);
//     });
//     allProfiles = [];
//     displayedProfiles = [];
//     fetchInitialData();
//     super.initState();
//   }

//   Future<void> fetchInitialData() async {
//     try {
//       final List<Siswa> profiles =
//           await apiService.getPosts(pageKey: 1, pageSize: _pageSize);
//       setState(() {
//         allProfiles = profiles;
//         displayedProfiles = allProfiles;
//       });
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   void showSortDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Pengaturan Sort'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RadioListTile<String>(
//                 title: const Text('Nama (A-Z)'),
//                 value: 'Nama (A-Z)',
//                 groupValue: selectedSorting,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedSorting = value!;
//                     sortProfiles();
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//               RadioListTile<String>(
//                 title: const Text('Nama (Z-A)'),
//                 value: 'Nama (Z-A)',
//                 groupValue: selectedSorting,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedSorting = value!;
//                     sortProfiles();
//                   });
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Data Siswa'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () async {
//               final String? result = await showSearch(
//                 context: context,
//                 delegate: DataSearch(allProfiles, _pagingController),
//               );

//               if (result != null && result.isNotEmpty) {
//                 filterProfiles(result);
//               }
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.sort),
//             onPressed: () {
//               showSortDialog(context);
//             },
//           ),
//         ],
//       ),
//       body: PagedListView<int, Siswa>(
//         pagingController: _pagingController,
//         builderDelegate: PagedChildBuilderDelegate<Siswa>(
//           itemBuilder: (context, item, index) => ListTile(
//             leading: Image.network(item.avatar.toString()),
//             title: Text("${item.firstName} ${item.lastName}"),
//             subtitle: Text(item.email.toString()),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DataSearch extends SearchDelegate<String> {
//   final List<Siswa> profiles;
//   final PagingController<int, Siswa> pagingController;
//   List<Siswa> suggestionList = [];

//   DataSearch(this.profiles, this.pagingController);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, ''),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     displayedProfiles = suggestionList;
//     pagingController.itemList = suggestionList;
//     return PagedListView<int, Siswa>(
//       pagingController: pagingController,
//       builderDelegate: PagedChildBuilderDelegate<Siswa>(
//         itemBuilder: (context, item, index) => ListTile(
//           title: Text(item.firstName ?? ""),
//           subtitle: Text(item.lastName ?? ""),
//           onTap: () {
//             close(context, item.firstName ?? "");
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     suggestionList = query.isEmpty
//         ? profiles
//         : profiles
//             .where((profile) =>
//                 profile.firstName!
//                     .toLowerCase()
//                     .contains(query.toLowerCase()) ||
//                 profile.lastName!.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//     displayedProfiles = suggestionList;
//     pagingController.itemList = suggestionList;
//     return PagedListView<int, Siswa>(
//       pagingController: pagingController,
//       builderDelegate: PagedChildBuilderDelegate<Siswa>(
//         itemBuilder: (context, item, index) => ListTile(
//           title: Text(suggestionList[index].firstName ?? ""),
//           subtitle: Text(suggestionList[index].lastName ?? ""),
//           onTap: () {
//             close(context, suggestionList[index].firstName ?? "");
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:coba_api_flutter/api_model.dart';
// import 'package:coba_api_flutter/api_provider.dart';
// import 'package:flutter/material.dart';

// class FourthDayBootcamp extends StatefulWidget {
//   const FourthDayBootcamp({super.key});

//   @override
//   _FourthDayBootcampState createState() => _FourthDayBootcampState();
// }

// class _FourthDayBootcampState extends State<FourthDayBootcamp> {
//   final ApiService _apiService = ApiService();
//   late Pokemon _pokemon;

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() async {
//     try {
//       Pokemon pokemon = await _apiService.getPokemon('pikachu');
//       setState(() {
//         _pokemon = pokemon;
//       });
//     } catch (error) {
//       print('Error: $error');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orange,
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
//         child: Center(
//           child: _pokemon != null
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [Icon(Icons.arrow_back_ios)],
//                     ),
//                     Image.network(_pokemon.frontImageUrl),
//                     Text('Pokemon Name: ${_pokemon.name}'),
//                     Text('Base Experience: ${_pokemon.baseExperience}'),
//                     Text('Height: ${_pokemon.height}'),
//                     Text('Weight: ${_pokemon.weight}'),
//                     const Text('Stats:'),
//                     for (var stat in _pokemon.stats)
//                       Text('${stat['stat']['name']}: ${stat['base_stat']}'),
//                   ],
//                 )
//               : const CircularProgressIndicator(),
//         ),
//       ),
//     );
//   }
// }
