import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
  });

  final int id;
  final String name;
  final String email;
  final String? bio;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      bio: json['bio'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, email, bio];
}
