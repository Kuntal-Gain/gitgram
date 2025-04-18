import 'package:gitgram/domain/entities/post_entity.dart';

import '../../repos/local_repository.dart';

class GetReposUseCase {
  final LocalRepository localRepository;

  GetReposUseCase(this.localRepository);

  Future<List<PostEntity>> call(String username) {
    return localRepository.getRepositories(username);
  }
}
