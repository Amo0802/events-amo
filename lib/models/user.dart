class User {
  final int? id;
  final String name;
  final String lastName;
  final String email;
  final bool isAdmin;
  //final City city;

  User({
    this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      lastName: json['lastName'],
      email: json['email'],
      isAdmin: json['admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'lastName': lastName,
        'email': email,
        'isAdmin': isAdmin,
      };
}