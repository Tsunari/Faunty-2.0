import '../models/places.dart';
import '../models/user_roles.dart';

class UserEntity {
  final String uid;
  final String email;
  final UserRole role;
  final Place place;

  UserEntity({
    required this.uid,
    required this.email,
    required this.role,
    required this.place,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'role': role.name, 'place': place.name};
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      uid: map['uid'] as String,
      email: map['email'] as String,
      role: UserRoleExtension.fromString(map['role'] as String),
      place: PlaceExtension.fromString(map['place'] as String),
    );
  }
}

extension UserRoleExtension on UserRole {
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.user,
    );
  }
}

//example usage
UserEntity testUser = UserEntity(
  uid: '123',
  email: 'test@example.com',
  role: UserRole.superuser,
  place: Place.munihFatih,
);
