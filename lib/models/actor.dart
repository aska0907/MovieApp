class Actor {
  final int id;
  final String name;
  final String profilePath;
  final String character;
  final String? biography;
  final DateTime? birthday;

  Actor({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.character,
    this.biography,
    this.birthday,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      character: json['character'] ?? '',
      biography: json['biography'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'profilePath': profilePath,
      'character': character,
      'biography': biography,
      'birthday': birthday?.toIso8601String(),
    };
  }

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
      id: map['id'],
      name: map['name'],
      profilePath: map['profilePath'],
      character: map['character'],
      biography: map['biography'],
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
    );
  }
}