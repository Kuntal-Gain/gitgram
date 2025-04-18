import '../../repos/local_repository.dart';

class IsSignInUseCase {
  final LocalRepository localRepository;

  IsSignInUseCase(this.localRepository);

  Future<bool> call() {
    return localRepository.isSignedIn();
  }
}
