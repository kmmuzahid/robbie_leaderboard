import 'package:get/get.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderBoardModel?> leaderBoardList = <LeaderBoardModel>[].obs;
  final RxBool isLoading = true.obs;
  void fetchData() async {
    isLoading.value = true;
    List<LeaderBoardModel?> response = [];
   
      response = await ApiGetService.fetchLeaderboardData();
   
    isLoading.value = false;
    response.sort(
      (a, b) => a!.currentRank.compareTo(b!.currentRank),
    );
    leaderBoardList.value = response;
  }
}
