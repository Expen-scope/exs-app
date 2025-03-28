class UserModel {
  final String name;
  final String email;
  final String token;
  final int id;
  final String createdAt;
  final String updatedAt;
  final String? profileImageUrl;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    this.profileImageUrl,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] as int? ?? 0,
      name: json['user']['name']?.toString() ?? 'غير معروف',
      email: json['user']['email']?.toString() ?? 'بريد غير معروف',
      token: json['authorisation']['token']?.toString() ?? '',
      createdAt: json['user']['created_at']?.toString() ?? '',
      updatedAt: json['user']['updated_at']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'profileImageUrl': profileImageUrl,
      };
  UserModel copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      id: id,
      token: token,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
