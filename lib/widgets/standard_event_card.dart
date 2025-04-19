import 'package:events_amo/detaljanDogadjaj/events_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StandardEventCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final DateTime date;
  final String location;

  const StandardEventCard({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFF1A1F38),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
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
                    'attendees': 34, // Sample data
                  },
                  isOfficial: true,
                ),
          ),
        );
        },
        borderRadius: BorderRadius.circular(15),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('E, MMM d • h:mm a').format(date),
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Bookmark icon
            Padding(
              padding: EdgeInsets.all(12),
              child: Icon(
                Icons.bookmark_border,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
