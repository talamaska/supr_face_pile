import 'dart:convert';

class PileUser {
  final String id;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  final String name;

  PileUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  }) : name = firstName + ' ' + lastName;

  PileUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) {
    return PileUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatarUrl': avatarUrl,
    };
  }

  factory PileUser.fromMap(Map<String, dynamic> map) {
    return PileUser(
      id: (map['id'] ?? '') as String,
      firstName: (map['firstName'] ?? '') as String,
      lastName: (map['lastName'] ?? '') as String,
      avatarUrl: (map['avatarUrl'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PileUser.fromJson(String source) =>
      PileUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PileUser &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        avatarUrl.hashCode;
  }
}
