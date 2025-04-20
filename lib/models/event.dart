enum Category {
  MUSIC,
  SPORTS,
  FOOD,
  ART,
  TECHNOLOGY,
}

enum City {
  PODGORICA,
  BERANE,
  NIKSIC,
  CETINJE,
  TIVAT,
  ULCIINJ,
  BUDVA,
  BAR,
  HERCEGNOVI,
  DANILOVGRAD,
  PLJEVLJA,
  KOLASIN,
  KOTOR,
}

class Event {
  final int? id;
  final String name;
  final String description;
  final City city;
  final DateTime startDateTime;
  final double price;
  final List<Category> categories;
  final int priority;
  final bool eventSaved;
  final bool eventAttending;
  final bool mainEvent;
  final bool promoted;
  final bool notification;

  Event({
    this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.startDateTime,
    required this.price,
    required this.categories,
    this.priority = 0,
    this.eventSaved = false,
    this.eventAttending = false,
    this.mainEvent = false,
    this.promoted = false,
    this.notification = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: City.values.firstWhere(
        (e) => e.toString() == 'City.${json['city']}',
        orElse: () => City.PODGORICA,
      ),
      startDateTime: DateTime.parse(json['startDateTime']),
      price: json['price'] is int ? (json['price'] as int).toDouble() : json['price'],
      categories: (json['categories'] as List)
          .map(
            (category) => Category.values.firstWhere(
              (e) => e.toString() == 'Category.$category',
              orElse: () => Category.MUSIC,
            ),
          )
          .toList(),
      priority: json['priority'] ?? 0,
      eventSaved: json['eventSaved'] ?? false,
      eventAttending: json['eventAttending'] ?? false,
      mainEvent: json['mainEvent'] ?? false,
      promoted: json['promoted'] ?? false,
      notification: json['notification'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'city': city.toString().split('.').last,
      'startDateTime': startDateTime.toIso8601String(),
      'price': price,
      'categories': categories.map((c) => c.toString().split('.').last).toList(),
      'priority': priority,
      'eventSaved': eventSaved,
      'eventAttending': eventAttending,
      'mainEvent': mainEvent,
      'promoted': promoted,
      'notification': notification,
    };
  }
}