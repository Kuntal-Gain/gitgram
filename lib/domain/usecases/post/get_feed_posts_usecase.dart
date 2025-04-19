import 'package:gitgram/domain/entities/post_entity.dart';

import '../../repos/local_repository.dart';

class GetFeedPostsUsecase {
  final LocalRepository localRepository;
  GetFeedPostsUsecase(this.localRepository);

  Future<List<PostEntity>> call(String username) {
    return localRepository.getFeedPosts(username);
  }
}
