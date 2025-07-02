import 'package:get/get.dart';
import 'package:the_leaderboard/models/faq_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class FaqScreenController extends GetxController {
  final RxList<FaqModel?> faqList = <FaqModel>[].obs;
  final RxBool isLoading = true.obs; 

  void fetchData() async {
    try {
      isLoading.value = true;
      final response = await ApiGetService.fetchFaq();
      if (response.isNotEmpty) {
        faqList.value = response;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    }
    isLoading.value = false;
  }
}
