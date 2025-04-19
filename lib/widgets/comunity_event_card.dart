import 'package:events_amo/detaljanDogadjaj/events_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityEventCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final DateTime date;
  final String location;
  final String organizer;
  final int attendees;
  final String category;

  const CommunityEventCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.organizer,
    required this.attendees,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EventDetailPage(
                  eventData: {
                    'title': title,
                    'image': imageUrl,
                    'date': date,
                    'location': location,
                    'organizer': organizer,
                    'attendees': attendees,
                    'category': category,
                  },
                  isOfficial: false,
                ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                // Category badge
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category, context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Date badge
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('MMM d').format(date),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "By $organizer",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.people_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "$attendees attending",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // RSVP to event
                          },
                          child: Text("Join"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          color: Colors.grey[400],
                        ),
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

  Color _getCategoryColor(String category, BuildContext context) {
    switch (category) {
      case 'wellness':
        return Colors.green;
      case 'social':
        return Colors.blue;
      case 'arts':
        return Colors.purple;
      case 'sports':
        return Colors.orange;
      case 'learning':
        return Colors.red;
      case 'food':
        return Colors.amber;
      case 'music':
        return Colors.pink;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
