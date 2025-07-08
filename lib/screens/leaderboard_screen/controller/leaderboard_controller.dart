import 'package:get/get.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderBoardModel?> leaderBoardList = <LeaderBoardModel>[].obs;
  final RxBool isLoading = true.obs;
  void fetchData() async {
    isLoading.value = true;
    final response = await ApiGetService.fetchLeaderboardData();
    isLoading.value = false;
    leaderBoardList.value = response;
  }

  LeaderBoardModel? rankedFirst() {
    return leaderBoardList.firstWhere(
      (element) => element!.currentRank == 1,
    );
  }

  LeaderBoardModel? rankedSecond() {
    return leaderBoardList.firstWhere(
      (element) => element!.currentRank == 2,
    );
  }

  LeaderBoardModel? rankedThird() {
    return leaderBoardList.firstWhere(
      (element) => element!.currentRank == 3,
    );
  }
}
