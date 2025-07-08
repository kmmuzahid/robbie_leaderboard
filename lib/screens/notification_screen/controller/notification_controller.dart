import 'package:get/get.dart';
import 'package:the_leaderboard/models/notification_model.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel?> notificationList = <NotificationModel>[].obs;

  void fetchNotification() async {
    final response = await ApiGetService.fetchNotification();
    if (response.isNotEmpty) {
      notificationList.value = response;
    }
  }
}
