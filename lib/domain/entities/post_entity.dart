import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final int id;
  final String nodeId;
  final String name;
  final String fullName;
  final bool private;
  final OwnerEntity owner;
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

  PostEntity({
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
  });

  @override
  List<Object?> get props => [
        id,
        nodeId,
        name,
        fullName,
        private,
        owner,
        htmlUrl,
        description,
        fork,
        createdAt,
        updatedAt,
        pushedAt,
        language,
        hasIssues,
        hasProjects,
        hasDownloads,
        hasWiki,
        forksCount,
        openIssuesCount,
        watchersCount,
        stargazersCount,
        visibility,
        defaultBranch,
      ];
}

class OwnerEntity extends Equatable {
  final String login;
  final int id;
  final String avatarUrl;
  final String htmlUrl;

  OwnerEntity({
    required this.login,
    required this.id,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  @override
  List<Object?> get props => [login, id, avatarUrl, htmlUrl];
}
