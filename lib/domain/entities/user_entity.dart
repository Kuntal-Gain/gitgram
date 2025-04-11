import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String login;
  final int id;
  final String avatarUrl;
  final String? name;
  final String? bio;
  final String? company;
  final String? location;
  final String? email;
  final String? twitterUsername;
  final String blog;
  final int publicRepos;
  final int followers;
  final int following;

  const UserEntity({
    required this.login,
    required this.id,
    required this.avatarUrl,
    this.name,
    this.bio,
    this.company,
    this.location,
    this.email,
    this.twitterUsername,
    this.blog = '',
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  @override
  List<Object?> get props => [
        login,
        id,
        avatarUrl,
        name,
        bio,
        company,
        location,
        email,
        twitterUsername,
        blog,
        publicRepos,
        followers,
        following,
      ];
}
