import 'package:get/get.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class TermAndConditionController extends GetxController {
  final RxString termAndCondition = ''.obs;

  void fetchData() async {
    try {
      final response = await ApiGetService.fetchTermAndCondition();     
      if (response.isNotEmpty) {
        termAndCondition.value = response.first!.text;        
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
  }
}
