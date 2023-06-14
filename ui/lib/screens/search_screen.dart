import 'dart:developer';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:ui/services/api/get.dart';
import 'package:ui/widgets/search_users_results.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  // final _debouncer = Debouncer

  Timer? _debounceTimer;
  int waitForMs = 500;

  List _searchResults = []; // wait for 500 ms

  void _onSearchTextChange(String searchText) {
    if (searchText != '') {
      if (_debounceTimer?.isActive ?? false) {
        // if there is an active timer
        // cancel it
        _debounceTimer?.cancel();
      }

      _debounceTimer = Timer(Duration(milliseconds: waitForMs), () async {
        List<dynamic> searchResults = await performUserSearch(searchText);
        if (kDebugMode) {
          log('The search results returned are ${searchResults.length}');
        }
        setState(() {
          _searchResults = searchResults;
        });
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.70;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.90,
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
                onChanged: _onSearchTextChange,
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
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              // show search results as scrollviewchild here
              UserNameSearchResultsWidget(
                height: maxHeight -
                    keyboardHeight -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
                searchResults: _searchResults,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
