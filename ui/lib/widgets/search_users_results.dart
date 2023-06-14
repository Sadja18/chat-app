import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UserNameSearchResultsWidget extends StatelessWidget {
  final List searchResults;
  final double height;
  const UserNameSearchResultsWidget(
      {super.key, required this.searchResults, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.90,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          // border: Border
          // shape: BoxShape.rectangle,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: searchResults
                .map(
                  (result) => ListTile(
                    title: Text(result),
                    onTap: () {
                      if (kDebugMode) {
                        log("make api request to get profile for userName:: $result");
                      }
                    },
                  ),
                )
                .toList(),
          ),
        )
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: searchResults.length,
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //         title: Text(searchResults[index]),
        //         onTap: () {
        //           if (kDebugMode) {
        //             log("make api request to get profile for userName:: ${searchResults[index]}");
        //           }
        //         },
        //       );
        //     },
        //   ),
        // ),
        );
  }
}
