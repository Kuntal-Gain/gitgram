import 'package:gitgram/domain/entities/user_entity.dart';

import '../../repos/local_repository.dart';

class GetSingleFollowingUsecase {
  final LocalRepository localRepository;
  GetSingleFollowingUsecase(this.localRepository);

  Future<UserEntity> call(String username) {
    return localRepository.getSingleFollowing(username);
  }
}
