import 'package:events_amo/pages/search_result.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchController,
            autofocus: true,
            onSubmitted: (query) {
              if (query.trim().isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SearchResultsPage(query: query),
                  ),
                );
              }
            },
            decoration: InputDecoration(
              hintText: "Search events",
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 80, color: Colors.grey[600]),
            SizedBox(height: 20),
            Text(
              "Search",
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
