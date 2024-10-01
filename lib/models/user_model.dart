class UserModel {
  final int streakCount;

  UserModel({required this.streakCount});

  UserModel copyWith({int? streakCount}) {
    return UserModel(
      streakCount: streakCount ?? this.streakCount,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      streakCount: json['streakCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'streakCount': streakCount,
    };
  }
}
