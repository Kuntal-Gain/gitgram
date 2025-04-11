import 'package:gitgram/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
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
        blog: json['blog'],
        publicRepos: json['public_repos'],
        followers: json['followers'],
        following: json['following'],
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
