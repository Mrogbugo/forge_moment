class AppUser {
  final String id;
  final String displayName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final bool isGuest;
  final bool twoFaEnabled;
  final String? kycStatus; // pending | verified | rejected | null

  const AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.isGuest = false,
    this.twoFaEnabled = false,
    this.kycStatus,
  });
}
