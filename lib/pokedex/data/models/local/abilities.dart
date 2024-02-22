import 'dart:convert';

class Abilities {
  final String name;
  Abilities({
    required this.name,
  });

  Abilities copyWith({
    String? name,
  }) {
    return Abilities(
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Abilities.fromMap(Map<String, dynamic> map) {
    return Abilities(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Abilities.fromJson(String source) => Abilities.fromMap(json.decode(source));

  @override
  String toString() => 'Abilities(name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Abilities &&
      other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}
