import 'package:get/get.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class LeaderboardController extends GetxController {
  final RxList<LeaderBoardModel?> leaderBoardList = <LeaderBoardModel>[].obs;

  void fetchData() async {
    final response = await ApiGetService.fetchLeaderboardData();
    leaderBoardList.value = response;
  }
}
