import "package:events_amo/detaljanDogadjaj/events_detail_page.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class ProfileEventCard extends StatelessWidget {
  final String title;
  final DateTime date;
  final String location;
  final String imageUrl;

  const ProfileEventCard({
    Key? key,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFF1A1F38),
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
                },
                isOfficial: false,
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
                width: 80,
                height: 80,
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
                          color: Theme.of(context).colorScheme.secondary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('E, MMM d').format(date),
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
                          color: Theme.of(context).colorScheme.secondary,
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
          ],
        ),
      ),
    );
  }
}