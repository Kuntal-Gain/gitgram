import 'package:gitgram/domain/repos/local_repository.dart';

class SignOutUseCase {
  final LocalRepository localRepository;

  SignOutUseCase(this.localRepository);

  Future<void> call() {
    return localRepository.signOut();
  }
}
