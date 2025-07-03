import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/hall_of_fame_single_payment_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class HomeScreenController extends RxController {
  final RxString name = ''.obs;
  final RxString totalRaised = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxInt rank = 0.obs;
  final RxMap recordSinglePayment = {}.obs;
  final RxMap consistentlyOntop = {}.obs;
  final RxMap mostEngagedProfile = {}.obs;

  // final Rxn<HallOfFameModel> recordSinglePayment = Rxn<HallOfFameModel>();
  // final Rxn<HallOfFameModel> consistentlyOntop = Rxn<HallOfFameModel>();
  // final Rxn<HallOfFameModel> mostEngagedProfile = Rxn<HallOfFameModel>();

  final RxBool ismydataLoading = true.obs;
  final RxBool ishallofframeLoading = true.obs;

  void fetchData() async {
    try {
      ismydataLoading.value = true;
      final data = await ApiGetService.fetchHomeData();

      if (data != null) {
        final userData = data.user;
        name.value = userData.name;
        totalRaised.value = userData.totalRaised.toString();
        totalSpent.value = userData.totalInvest.toString();
        rank.value = userData.rank;
      }
      ismydataLoading.value = false;
      ishallofframeLoading.value = true;
      final temp1 = await ApiGetService.fetchHallofFrameEngagedProfile();
      mostEngagedProfile.value = temp1;
      print(mostEngagedProfile["name"]);
      ishallofframeLoading.value = false;
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }

  // void fetchHallofFrame() async {
  //   try {
  //     recordSinglePayment.value =
  //         await ApiGetService.fetchHallofFrame(AppUrls.highestInvestor);
  //     print(recordSinglePayment.value);
  //     consistentlyOntop.value =
  //         await ApiGetService.fetchHallofFrame(AppUrls.consecutiveToper);
  //     print(consistentlyOntop.value);
  //     mostEngagedProfile.value =
  //         await ApiGetService.fetchHallofFrame(AppUrls.mostViewed);
  //     print(mostEngagedProfile.value);
  //   } catch (e) {
  //     Get.snackbar("Error", "Something went wrong");
  //   }
  // }
}
