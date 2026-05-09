enum UserRole {
  member,
  admin;

  static UserRole fromString(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        return UserRole.admin;

      case 'MEMBER':
      default:
        return UserRole.member;
    }
  }

  String toText() {
    switch (this) {
      case UserRole.admin:
        return 'ADMIN';

      case UserRole.member:
        return 'MEMBER';
    }
  }
}