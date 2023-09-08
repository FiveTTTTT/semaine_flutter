import 'dart:convert';

class User {
  String? userId;
  String? username;

  User({
    this.userId,
    this.username,
  });

  User copyWith({
    String? userId,
    String? username,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (userId != null) {
      result.addAll({'userId': userId});
    }
    if (username != null) {
      result.addAll({'username': username});
    }

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId']?.toInt(),
        username: map['username']
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(userId: $userId, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User && other.userId == userId && other.username == username;
  }
}
