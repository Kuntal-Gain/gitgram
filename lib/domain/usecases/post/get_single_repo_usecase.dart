import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/domain/repos/local_repository.dart';

class GetSingleRepoUseCase {
  final LocalRepository localRepository;

  GetSingleRepoUseCase(this.localRepository);

  Future<PostEntity> call(String username, String repoId) {
    return localRepository.getSingleRepository(username, repoId);
  }
}
