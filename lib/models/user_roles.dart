enum UserRole { superuser, hoca, baskan, talebe, user }

extension UserRoleExtension on UserRole {
  String get name {
    switch (this) {
      case UserRole.superuser:
        return 'Superuser';
      case UserRole.hoca:
        return 'Hoca';
      case UserRole.baskan:
        return 'Baskan';
      case UserRole.talebe:
        return 'Talebe';
      case UserRole.user:
        return 'User';
    }
  }

  // Example role-specific function
  void doRoleSpecificAction() {
    switch (this) {
      case UserRole.superuser:
        print('Superuser action');
        break;
      case UserRole.hoca:
        print('Hoca action');
        break;
      case UserRole.baskan:
        print('Baskan action');
        break;
      case UserRole.talebe:
        print('Talebe action');
        break;
      case UserRole.user:
        print('User action');
        break;
    }
  }
}

UserRole userRoleFromString(String role) {
  switch (role) {
    case 'Superuser':
      return UserRole.superuser;
    case 'Hoca':
      return UserRole.hoca;
    case 'Baskan':
      return UserRole.baskan;
    case 'Talebe':
      return UserRole.talebe;
    case 'User':
    default:
      return UserRole.user;
  }
}
