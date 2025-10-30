import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:the_leaderboard/common/app_log.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/hall_of_fame_single_payment_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_consisntantly_top_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_most_engaged_model.dart';
import 'package:the_leaderboard/models/profile_model.dart';
import 'package:the_leaderboard/models/recent_activity_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:the_leaderboard/screens/notification_screen/controller/notification_controller.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/services/api/api_get_service.dart';
import 'package:the_leaderboard/services/api/api_post_service.dart';
import 'package:the_leaderboard/services/socket/socket_service.dart';
import 'package:the_leaderboard/services/storage/storage_keys.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';

class HomeScreenController extends GetxController {
  final RxString name = ''.obs;
  final RxString totalRaised = ''.obs;
  final RxString totalSpent = ''.obs;
  final RxInt rank = 0.obs;
  final RxString image = "".obs;
  final RxString userCode = "".obs;
  final Rxn<HallOfFameSinglePaymentModel> recoredSinglePayment =
      Rxn<HallOfFameSinglePaymentModel>();
  final Rxn<HallOfFrameConsisntantlyTopModel> consistantlyTop =
      Rxn<HallOfFrameConsisntantlyTopModel>();
  final Rxn<HallOfFrameMostEngagedModel> mostEngaged = Rxn<HallOfFrameMostEngagedModel>();

  final RxBool ismydataLoading = true.obs;
  final RxBool ishallofframeSinglePaymentLoading = true.obs;
  final RxBool ishallofframeConsisntantTopLoading = true.obs;
  final RxBool ishallofframeMostEngagedLoading = true.obs;

  final RxList<RecentActivityModel> recentActivity = <RecentActivityModel>[].obs;
  final notificationController = Get.find<NotificationController>();
  void sendData() {
    SocketService.instance.sendInvest("Aurnab 420", 200);
  }

  fetchRecentActivity() async {
    final response = await ApiGetService.apiGetServiceQuery(AppUrls.notification,
        queryParameters: {'type': 'global', 'limit': '10'});
    isLoading.value = false;
    if (response != null) {
      final jsonbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final List data = jsonbody["data"];
        recentActivity.value = data.map((e) => RecentActivityModel.fromJson(e)).toList();
      } else {
        Get.snackbar(
          "Error",
          jsonbody["message"],
          colorText: AppColors.white,
        );
      }
    }
  }

  void receiveData() {
    SocketService.instance.onNewInvestMessageReceived((p0) {
      recentActivity.insert(
          0,
          RecentActivityModel(
              id: '',
              title: p0.title,
              text: p0.subTitle,
              type: p0.type,
              createdAt: DateTime.parse(p0.createdAt)));
    });
    SocketService.instance.onCreatingTicketResponse(
      (p0) {
        recentActivity.insert(
            0,
            RecentActivityModel(
                id: '',
                title: p0.title,
                text: p0.text,
                type: p0.type,
                createdAt: DateTime.parse(p0.createdAt)));
      },
    );
  }

  Future fetchData({bool isUpdating = false}) async {
    fetchHomeData(isUpdating);
    fetchHallofFrameSinglePayment(isUpdating);
    fetchHallofFrameConsistantlyTop(isUpdating);
    fetchHallofFrameMostEngaged(isUpdating);
    Get.find<ProfileScreenController>().fetchProfile(isUpdating: isUpdating);
    fetchRecentActivity();
    appLog("User email: ${LocalStorage.myEmail} and user id: ${LocalStorage.userId}");
    // await Purchases.configure(
    //   PurchasesConfiguration("goog_gsyjGglgxeOOHLKmCuTaOliiTFa")
    //     ..appUserID = LocalStorage.userId, // optional
    // );
  }

  void viewMyProfile() {
    Get.put(BottomNavController());
    final profileTab = Get.find<BottomNavController>();
    profileTab.changeIndex(3);
  }

  void fetchHomeData(bool isUpdating) async {
    appLog("fetching home data");
    try {
      ismydataLoading.value = isUpdating ? false : true;
      final responseHomeData = await ApiGetService.apiGetService(AppUrls.profile);
      ismydataLoading.value = false;
      if (responseHomeData != null) {
        final data = jsonDecode(responseHomeData.body);
        if (responseHomeData.statusCode == 200) {
          final userData = ProfileResponseModel.fromJson(data["data"]).user;
          name.value = userData?.name ?? "";
          totalRaised.value = AppCommonFunction.formatNumber(userData?.totalRaised);
          totalSpent.value = AppCommonFunction.formatNumber(userData?.totalInvest ?? "");
          rank.value = userData?.rank ?? 0;
          image.value = userData?.profileImg ?? "";
          userCode.value = userData?.userCode ?? "";
          LocalStorage.userId = userData?.id ?? "";
          LocalStorage.setString(LocalStorageKeys.userId, LocalStorage.userId);
          update();
          return;
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      } else {
        Get.toNamed(AppRoutes.serverOff);
      }
    } catch (e) {
      errorLog("fetchHomeData", e);
    }
  }

  void fetchHallofFrameSinglePayment(bool isUpdating) async {
    appLog("fetching single payment data");
    ishallofframeSinglePaymentLoading.value = isUpdating ? false : true;
    try {
      final response = await ApiGetService.apiGetService(AppUrls.highestInvestor);
      ishallofframeSinglePaymentLoading.value = false;
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          recoredSinglePayment.value = HallOfFameSinglePaymentModel.fromJson(data["data"]);
          return;
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    // recoredSinglePayment.value = HallOfFameSinglePaymentModel(
    //     id: "0",
    //     name: "Unknown",
    //     country: "Unknown",
    //     gender: "Unknown",
    //     views: 0,
    //     totalInvested: 0,  profileImg: '');
  }

  void fetchHallofFrameConsistantlyTop(bool isUpdating) async {
    appLog("fetching consistantly top ");
    ishallofframeConsisntantTopLoading.value = isUpdating ? false : true;
    try {
      final response = await ApiGetService.apiGetService(AppUrls.consecutiveToper);
      ishallofframeConsisntantTopLoading.value = false;
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          consistantlyTop.value = HallOfFrameConsisntantlyTopModel.fromJson(data["data"]);
          return;
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    // consistantlyTop.value = HallOfFrameConsisntantlyTopModel(
    //     id: "0", name: "Unknown", timesRankedTop: 0);
  }

  void fetchHallofFrameMostEngaged(bool isUpdating) async {
    appLog("fetching most engaged");
    ishallofframeMostEngagedLoading.value = isUpdating ? false : true;
    try {
      final response = await ApiGetService.apiGetService(AppUrls.mostViewed);
      ishallofframeMostEngagedLoading.value = false;
      if (response != null) {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          mostEngaged.value = HallOfFrameMostEngagedModel.fromJson(data["data"]);
          return;
        } else {
          Get.closeAllSnackbars();
          Get.snackbar("Error", data["message"], colorText: AppColors.white);
        }
      }
      appLog("Succeed");
    } catch (e) {
      errorLog("Failed", e);
    }
    // mostEngaged.value = HallOfFrameMostEngagedModel(
    //     id: "0",
    //     name: "Unnknown",
    //     country: "Unknown",
    //     gender: "Unknown",
    //     profileImg: '',
    //     views: 0);
  }

  // void purchaseProduct(Package packageToPurchase) async {
  //   try {
  //     // Attempt to purchase the selected package
  //     PurchaseResult purchaseResult =
  //         await Purchases.purchasePackage(packageToPurchase);
  //     appLog(purchaseResult);

  //     // print(purchaseResult);
  //     // Check if the entitlement is active
  //     bool isPurchased = purchaseResult.customerInfo.entitlements.active
  //         .containsKey(AppStrings.leaderboardInvestEntitlement);
  //     appLog(isPurchased);
  //     // print(isPurchased);
  //     if (isPurchased) {
  //       // The user has unlocked the entitlement — grant access here
  //     }
  //   } on PurchasesError catch (e) {
  //     // Handle different error scenarios (e.g., cancellation, network issues)
  //     appLog(e);
  //   }
  // }

  void onJoinLeaderboard(BuildContext context) async {
    initialize();
    // Offerings offerings = await Purchases.getOfferings();
    // List<Package> package = [];
    // if (offerings.current != null &&
    //     offerings.current!.availablePackages.isNotEmpty) {
    //   package = offerings.current!.availablePackages;
    //   appLog(package);
    // }
    // showModalBottomSheet(
    //   context: context,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    //   ),
    //   // allows full height if needed
    //   builder: (context) {
    //     return Container(
    //         padding: EdgeInsets.all(16),
    //         width: double.infinity,
    //         child: ListView.builder(
    //           itemCount: package.length,
    //           itemBuilder: (context, index) {
    //             final product = package[index].storeProduct;
    //             return Card(
    //               child: ListTile(
    //                 title: Text(product.description),
    //                 trailing: Text(
    //                   product.priceString,
    //                   style:
    //                       TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
    //                 ),
    //                 subtitle: Text(product.identifier),
    //                 onTap: () => purchaseProduct(package[index]),
    //               ),
    //             );
    //           },
    //         ));
    //   },
    // );
  }

  //----------------in app purchase

  final InAppPurchase _iap = InAppPurchase.instance;

  // Observables
  var isStoreAvailable = false.obs;
  var isLoading = false.obs;
  var products = <ProductDetails>[].obs;

  final Set<String> _productIds = {
    "leaderboard_1",
    "leaderboard_3",
    "leaderboard_5",
    "theleaderboard_10",
    "theleaderbaord_100",
    "theleaderboard_250",
    "theleaderboard_50",
    "theleaderboard_500",
  };

  final Set<String> _productIdsIos = {
    "TheLeaderboard_030",
    // "TheLeaderboard_3",
    // "TheLeaderboard_5",
    // "TheLeaderboard_10",
    // "TheLeaderboard_20",
    // "TheLeaderboard_50",
    // "TheLeaderboard_100",
    // "TheLeaderboard_250",
    // "TheLeaderboard_500",
    // "TheLeaderboard_1000"
  };

  void initialize() async {
    isLoading.value = true;

    final available = await _iap.isAvailable();
    isStoreAvailable.value = available;

    if (!available) {
      isLoading.value = false;

      Get.snackbar('Store Error', 'In-app purchases not available');
      return;
    }

    final response =
        await _iap.queryProductDetails(Platform.isAndroid ? _productIds : _productIdsIos);
    if (response.error != null || response.productDetails.isEmpty) {
      // Get.snackbar('Error', 'No products found');
    } else {
      products.assignAll(response.productDetails);
      appLog(products.length.toString());
    }

    isLoading.value = false;

    _showProductSelectorBottomSheet();
  }

  void _listenToPurchases() {
    _iap.purchaseStream.listen((purchases) async {
      for (final purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }

          await ApiPostService.apiPostService(AppUrls.paymentsuccess, {
            "product_id": purchase.productID,
            "purchase_token": purchase.purchaseID,
            "transaction_date": purchase.transactionDate,
            "verification_data": {
              "localVerificationData": purchase.verificationData.localVerificationData,
              "serverVerificationData": purchase.verificationData.serverVerificationData,
              "source": purchase.verificationData.source,
            }
          });
          await fetchData();

          Get.snackbar('Success', 'Purchased: ${purchase.productID}');
        } else if (purchase.status == PurchaseStatus.error) {
          Get.snackbar('Error', 'Purchase failed');
        }
      }
    });
  }

  void buyProduct(ProductDetails product) {
    final param = PurchaseParam(productDetails: product);
    _iap.buyConsumable(purchaseParam: param, autoConsume: true);
  }

  void _showProductSelectorBottomSheet() {
    Get.bottomSheet(
      Obx(() {
        return products.isEmpty
            ? ConstrainedBox(
                constraints: BoxConstraints(maxHeight: Get.size.height * .4),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: AppColors.blueDark,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Couldn’t load purchase options. Please refresh or try again soon.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.redDark),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 24),
                color: AppColors.blueDark,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: Get.size.height * 0.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag handle
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Title/Header
                      const Text(
                        'Choose Your Purchase Amount',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Product list
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: products.map((product) {
                              return Card(
                                  color: AppColors.blue,
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.back(); // Close bottom sheet
                                      buyProduct(product);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                product.title.split('(').last.replaceAll(')', ''),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.gradientColorEnd,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                product.price,
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            product.description.replaceAll('\n', ' '),
                                            style: const TextStyle(
                                                fontSize: 14, color: AppColors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
    SocketService.instance.connect();
    receiveData();
    _listenToPurchases();
  }
}
