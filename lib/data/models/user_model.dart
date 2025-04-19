// ignore_for_file: overridden_fields

import 'package:gitgram/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  @override
  final String login;
  @override
  final int id;
  @override
  final String avatarUrl;
  @override
  final String? name;
  @override
  final String? bio;
  @override
  final String? company;
  @override
  final String? location;
  @override
  final String? email;
  @override
  final String? twitterUsername;
  @override
  final String blog;
  @override
  final int publicRepos;
  @override
  final int followers;
  @override
  final int following;

  const UserModel({
    required this.login,
    required this.id,
    required this.avatarUrl,
    this.name,
    this.bio,
    this.company,
    this.location,
    this.email,
    this.twitterUsername,
    required this.blog,
    required this.publicRepos,
    required this.followers,
    required this.following,
  }) : super(
          login: login,
          id: id,
          avatarUrl: avatarUrl,
          name: name,
          bio: bio,
          company: company,
          location: location,
          email: email,
          twitterUsername: twitterUsername,
          blog: blog,
          publicRepos: publicRepos,
          followers: followers,
          following: following,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        login: json['login'],
        id: json['id'],
        avatarUrl: json['avatar_url'],
        name: json['name'],
        bio: json['bio'],
        company: json['company'],
        location: json['location'],
        email: json['email'],
        twitterUsername: json['twitter_username'],
        blog: json['blog'] ?? "",
        publicRepos: json['public_repos'] ?? 0,
        followers: json['followers'] ?? 0,
        following: json['following'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'login': login,
        'id': id,
        'avatar_url': avatarUrl,
        'name': name,
        'bio': bio,
        'company': company,
        'location': location,
        'email': email,
        'twitter_username': twitterUsername,
        'blog': blog,
        'public_repos': publicRepos,
        'followers': followers,
        'following': following,
      };
}
