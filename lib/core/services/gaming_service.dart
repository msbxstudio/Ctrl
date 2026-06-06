import 'package:games_services/games_services.dart';

import 'app_service.dart';

final class GamingService extends AppService<GamesServices?> {
  static final instance = GamingService._();

  GamingService._() : super(null);

  @override
  void initialize() {
    if (isInitialized) return;

    setInitialized(true);
  }

  @override
  void dispose() {
    setInitialized(false);
  }

  Future<void> signIn() async {
    if (await GamesServices.isSignedIn) return;
    await GamesServices.signIn();
  }

  Future<void> unlockAchievement(String id) async {
    await GamesServices.unlock(
      achievement: Achievement(androidID: id, iOSID: id),
    );
  }

  Future<void> submitScore(int score) async {
    await GamesServices.submitScore(
      score: Score(
        androidLeaderboardID: 'highscore',
        iOSLeaderboardID: 'highscore',
        value: score,
      ),
    );
  }
}
