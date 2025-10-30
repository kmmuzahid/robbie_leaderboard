import 'package:get/get.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/screens/search_screen/controller/search_screen_controller.dart';
class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => LeaderboardController(), fenix: true);
    Get.lazyPut(() => ProfileScreenController(), fenix: true);
    Get.lazyPut(() => SearchScreenController(), fenix: true);
    // Get.lazyPut(() => NotificationController());
    // Get.lazyPut(() => ApplicationDetailsController());
  }
}
