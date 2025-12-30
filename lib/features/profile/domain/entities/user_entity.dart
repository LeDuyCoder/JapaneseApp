class UserEntity {
  final String uid;
  final String? displayName;
  final String? email;

  const UserEntity({
    required this.uid,
    this.displayName,
    this.email,
  });
}