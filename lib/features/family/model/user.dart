import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  const User({
    this.id,
    required this.nome,
    required this.avatarImage,
  });

  static User firstUser(){
    return const User(id: 1, nome: "Mario Rossi", avatarImage: "assets/images/avatars/avatar_default.png");
  }

  /// Creates a User from Json map
  factory User.fromJson(Map<String, dynamic> data) => _$UserFromJson(data);

  final int? id;
  final String nome;
  final String avatarImage;

  /// Creates a copy of the current User with property changes
  User copyWith({ 
    int? id,
    String? nome,
    String? avatarImage,
  }) {
    return User(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      avatarImage: avatarImage ?? this.avatarImage,
    );
  }
  
  @override
  List<Object?> get props => [
        id,
        nome,
        avatarImage,
      ];

  /// Creates a Json map from a User
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
