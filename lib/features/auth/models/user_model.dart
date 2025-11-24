/// User model
class UserModel {
  const UserModel({required this.id, required this.email, this.name, this.avatarUrl, this.isPro = false});

  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;
  final bool isPro;

  UserModel copyWith({String? id, String? email, String? name, String? avatarUrl, bool? isPro}) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPro: isPro ?? this.isPro,
    );
  }

  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name!.substring(0, name!.length >= 2 ? 2 : 1).toUpperCase();
    }
    return email.substring(0, 2).toUpperCase();
  }

  String get displayName => name ?? email.split('@').first;
}
