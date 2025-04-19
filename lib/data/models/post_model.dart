// ignore_for_file: annotate_overrides, overridden_fields

import 'package:gitgram/domain/entities/post_entity.dart';

class PostModel extends PostEntity {
  final int id;
  final String nodeId;
  final String name;
  final String fullName;
  final bool private;
  final OwnerModel owner;
  final String htmlUrl;
  final String description;
  final bool fork;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime pushedAt;
  final String language;
  final bool hasIssues;
  final bool hasProjects;
  final bool hasDownloads;
  final bool hasWiki;
  final int forksCount;
  final int openIssuesCount;
  final int watchersCount;
  final int stargazersCount;
  final String visibility;
  final String defaultBranch;

  const PostModel({
    required this.id,
    required this.nodeId,
    required this.name,
    required this.fullName,
    required this.private,
    required this.owner,
    required this.htmlUrl,
    required this.description,
    required this.fork,
    required this.createdAt,
    required this.updatedAt,
    required this.pushedAt,
    required this.language,
    required this.hasIssues,
    required this.hasProjects,
    required this.hasDownloads,
    required this.hasWiki,
    required this.forksCount,
    required this.openIssuesCount,
    required this.watchersCount,
    required this.stargazersCount,
    required this.visibility,
    required this.defaultBranch,
  }) : super(
          id: id,
          nodeId: nodeId,
          name: name,
          fullName: fullName,
          private: private,
          owner: owner,
          htmlUrl: htmlUrl,
          description: description,
          fork: fork,
          createdAt: createdAt,
          updatedAt: updatedAt,
          pushedAt: pushedAt,
          language: language,
          hasIssues: hasIssues,
          hasProjects: hasProjects,
          hasDownloads: hasDownloads,
          hasWiki: hasWiki,
          forksCount: forksCount,
          openIssuesCount: openIssuesCount,
          watchersCount: watchersCount,
          stargazersCount: stargazersCount,
          visibility: visibility,
          defaultBranch: defaultBranch,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      nodeId: json['node_id'],
      name: json['name'],
      fullName: json['full_name'],
      private: json['private'],
      owner: OwnerModel.fromJson(json['owner']),
      htmlUrl: json['html_url'],
      description: json['description'] ?? 'No description available',
      fork: json['fork'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pushedAt: DateTime.parse(json['pushed_at']),
      language: json['language'] ?? 'Unknown',
      hasIssues: json['has_issues'],
      hasProjects: json['has_projects'],
      hasDownloads: json['has_downloads'],
      hasWiki: json['has_wiki'],
      forksCount: json['forks_count'],
      openIssuesCount: json['open_issues_count'],
      watchersCount: json['watchers_count'],
      stargazersCount: json['stargazers_count'],
      visibility: json['visibility'],
      defaultBranch: json['default_branch'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'node_id': nodeId,
        'name': name,
        'full_name': fullName,
        'private': private,
        'owner': owner.toJson(),
        'html_url': htmlUrl,
        'description': description,
        'fork': fork,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'pushed_at': pushedAt.toIso8601String(),
        'language': language,
        'has_issues': hasIssues,
        'has_projects': hasProjects,
        'has_downloads': hasDownloads,
        'has_wiki': hasWiki,
        'forks_count': forksCount,
        'open_issues_count': openIssuesCount,
        'watchers_count': watchersCount,
        'stargazers_count': stargazersCount,
        'visibility': visibility,
        'default_branch': defaultBranch,
      };
}

class OwnerModel extends OwnerEntity {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;

  const OwnerModel({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
  }) : super(
          login: login,
          id: id,
          avatarUrl: avatarUrl,
          htmlUrl: htmlUrl,
        );

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      login: json['login'],
      id: json['id'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'login': login,
        'id': id,
        'avatar_url': avatarUrl,
        'html_url': htmlUrl,
      };
}
