import 'package:events_amo/detaljanDogadjaj/events_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeaturedEventCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final DateTime date;
  final String location;
  final bool isPromoted;

  const FeaturedEventCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
    this.isPromoted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen size to make layout responsive
    final Size screenSize = MediaQuery.of(context).size;
    final double cardWidth = screenSize.width < 600 ? screenSize.width * 0.8 : 300;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(
              eventData: {
                'title': title,
                'image': imageUrl,
                'date': date,
                'location': location,
                'isPromoted': isPromoted,
                'attendees': 42,
              },
              isOfficial: true,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.all(8),
        // Removed fixed height constraint to allow content to determine size
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              Color(0xFF1F2533),
              Color(0xFF131824),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes only needed space
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with aspect ratio
            AspectRatio(
              aspectRatio: 16 / 9, // Standard widescreen ratio
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      // Added error and loading handling
                      errorBuilder: (context, error, stackTrace) => 
                        Container(
                          color: Colors.grey[800],
                          child: Icon(Icons.error, color: Colors.white),
                        ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  // Date badge
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.02, // Responsive padding
                        vertical: screenSize.width * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormat('MMM d').format(date),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          // Responsive font size
                          fontSize: screenSize.width < 600 ? 12 : 14,
                        ),
                      ),
                    ),
                  ),
                  // Promoted badge
                  if (isPromoted)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.02, // Responsive padding
                          vertical: screenSize.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: screenSize.width < 600 ? 12 : 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "PROMOTED",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.width < 600 ? 10 : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Content
            Padding(
              // Dynamic padding based on screen size
              padding: EdgeInsets.all(screenSize.width < 600 ? 12 : 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Takes minimum space
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenSize.width < 600 ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2, // Allow 2 lines for title
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenSize.width < 600 ? 6 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: screenSize.width < 600 ? 14 : 16,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: screenSize.width < 600 ? 12 : 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.width < 600 ? 10 : 15),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.grey[400],
                          size: screenSize.width < 600 ? 20 : 24,
                        ),
                        // Use visualDensity for responsive button sizing
                        visualDensity: screenSize.width < 600 
                          ? VisualDensity.compact 
                          : VisualDensity.standard,
                        onPressed: () {
                          // Save event
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}