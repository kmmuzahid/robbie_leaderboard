import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/hall_of_fame_single_payment_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_consisntantly_top_model.dart';
import 'package:the_leaderboard/models/hall_of_frame_most_engaged_model.dart';
import 'package:the_leaderboard/models/profile_model.dart';
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

  final RxList<List<dynamic>> recentActivity = <List<dynamic>>[].obs;
  final notificationController = Get.find<NotificationController>();
  void sendData() {
    SocketService.instance.sendInvest("Aurnab 420", 200);
  }

  void receiveData() {
    SocketService.instance.onNewInvestMessageReceived((p0) {
      final time = DateFormat('mm').format(DateTime.parse(p0.createdAt));
      recentActivity.insert(0, [p0.title, p0.subTitle, time]);
    });
    SocketService.instance.onCreatingTicketResponse(
      (p0) {
        final time = DateFormat('mm').format(DateTime.parse(p0.createdAt));
        recentActivity.insert(0, [p0.title, p0.text, time]);
      },
    );
  }

  Future fetchData() async {
    fetchHomeData();
    fetchHallofFrameSinglePayment();
    fetchHallofFrameConsistantlyTop();
    fetchHallofFrameMostEngaged();
    Get.put(ProfileScreenController());
    await Get.find<ProfileScreenController>().fetchProfile();

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

  void fetchHomeData() async {
    appLog("fetching home data");
    try {
      ismydataLoading.value = true;
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

  void fetchHallofFrameSinglePayment() async {
    appLog("fetching single payment data");
    ishallofframeSinglePaymentLoading.value = true;
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

  void fetchHallofFrameConsistantlyTop() async {
    appLog("fetching consistantly top ");
    try {
      ishallofframeConsisntantTopLoading.value = true;
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

  void fetchHallofFrameMostEngaged() async {
    appLog("fetching most engaged");
    try {
      ishallofframeMostEngagedLoading.value = true;
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
    "theleaderbaord_100",
    "theleaderboard_10",
    "theleaderboard_250",
    "theleaderboard_50",
    "theleaderboard_500",
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

    final response = await _iap.queryProductDetails(_productIds);
    if (response.error != null || response.productDetails.isEmpty) {
      Get.snackbar('Error', 'No products found');
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
            ? Container(
                padding: const EdgeInsets.all(16),
                child: const Center(child: Text('No products found')),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: products.map((product) {
                      return ListTile(
                        title: Text(product.title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(product.description),
                        trailing: Text(product.price, style: const TextStyle(color: Colors.green)),
                        onTap: () {
                          Get.back(); // Close bottom sheet
                          buyProduct(product);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
      }),
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
