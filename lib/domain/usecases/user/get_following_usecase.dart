import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:gitgram/domain/repos/local_repository.dart';

class GetFollowingUsecase {
  final LocalRepository localRepository;
  GetFollowingUsecase(this.localRepository);

  Future<List<UserEntity>> call(String username) {
    return localRepository.getFollowings(username);
  }
}
