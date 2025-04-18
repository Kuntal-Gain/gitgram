import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:gitgram/domain/repos/local_repository.dart';

class GetCurrentUserUsecase {
  final LocalRepository localRepository;

  GetCurrentUserUsecase(this.localRepository);

  Future<UserEntity> call(String token) {
    return localRepository.getCurrentUser(token);
  }
}
