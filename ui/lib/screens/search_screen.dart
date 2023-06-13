import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.80,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: const BoxDecoration(
            color: Colors.amberAccent,
            backgroundBlendMode: BlendMode.colorBurn),
        child: Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width * 0.90,
          margin: const EdgeInsetsDirectional.fromSTEB(4.0, 5.0, 5.0, 4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      // Perform search logic here
                      String searchQuery = _searchController.text;
                      if (kDebugMode) {
                        log('Search Query: $searchQuery');
                      }
                    },
                  ),
                ),
              ),
              // show search results as scrollviewchild here
            ],
          ),
        ),
      ),
    );
  }
}
