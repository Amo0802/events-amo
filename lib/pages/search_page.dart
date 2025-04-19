import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Search events, categories, people...",
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[400],
              ),
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
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey[600],
            ),
            SizedBox(height: 20),
            Text(
              "Search for events, categories, or people",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
