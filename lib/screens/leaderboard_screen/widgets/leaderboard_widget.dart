import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({
    Key? key,
    required this.leaderboard,
    required this.onRefresh,
    required this.scrollController,
    this.showSelf = true,
  }) : super(key: key);

  final List<LeaderBoardModel?> leaderboard;
  final Function() onRefresh;
  final bool showSelf;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return buildLeaderboardTabView(leaderboard);
  }

  Widget buildLeaderboardTabView(List<LeaderBoardModel?> leaderboard) {
    try {
      final filteredList = leaderboard.skip(3).where((e) => e != null).toList();

      final myData = filteredList.firstWhere(
        (element) => element!.userId == StorageService.userId,
        orElse: () => LeaderBoardModel.empty(),
      );
      final myIndex = filteredList.indexWhere(
        (element) => element?.userId == StorageService.userId,
      );
      bool showFloating = true;

      return Column(
        children: [
          // const SpaceWidget(spaceHeight: 20),

          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //rank two
                if (leaderboard.length > 1)
                  InkWell(
                    onTap: () {
                      final userid = leaderboard[1]?.userId;
                      Get.toNamed(
                        AppRoutes.otherProfileScreen,
                        arguments: userid,
                      );
                    },
                    child: Transform.translate(
                      offset: Offset.zero,
                      child: TopRankedItem(
                        shoutTitle: leaderboard[1]!.shoutTitle,
                        fromOnline: leaderboard[1]!.profileImg != "Unknown",
                        rankLabel: leaderboard[1]!.currentRank.toString(),
                        name: leaderboard[1]!.name,
                        amount: "\$${AppCommonFunction.formatNumber(leaderboard[1]!.totalInvest)}",
                        image: leaderboard[1]!.profileImg != "Unknown"
                            ? leaderboard[1]!.profileImg
                            : AppImagePath.profileImage,
                        rankColor: AppColors.greyDark,
                        avatarSize: 40,
                      ),
                    ),
                  ),
                //rank one
                if (leaderboard.isNotEmpty)
                  InkWell(
                    onTap: () {
                      final userId = leaderboard[0]!.userId;
                      Get.toNamed(
                        AppRoutes.otherProfileScreen,
                        arguments: userId,
                      );
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -10),
                      child: TopRankedItem(
                        shoutTitle: leaderboard[0]!.shoutTitle,
                        fromOnline: leaderboard[0]!.profileImg != "Unknown",
                        rankLabel: leaderboard[0]!.currentRank.toString(),
                        name: leaderboard[0]!.name,
                        amount: "\$${AppCommonFunction.formatNumber(leaderboard[0]!.totalInvest)}",
                        image: leaderboard[0]!.profileImg != "Unknown"
                            ? leaderboard[0]!.profileImg
                            : AppImagePath.profileImage,
                        rankColor: AppColors.yellow,
                        avatarSize: 55,
                      ),
                    ),
                  ),
                //rank 3
                if (leaderboard.length > 2)
                  InkWell(
                    onTap: () {
                      final userId = leaderboard[2]!.userId;
                      Get.toNamed(
                        AppRoutes.otherProfileScreen,
                        arguments: userId,
                      );
                    },
                    child: Transform.translate(
                      offset: Offset.zero,
                      child: TopRankedItem(
                        shoutTitle: leaderboard[2]!.shoutTitle,
                        fromOnline: leaderboard[2]!.profileImg != "Unknown",
                        rankLabel: leaderboard[2]!.currentRank.toString(),
                        name: leaderboard[2]!.name,
                        amount: "\$${AppCommonFunction.formatNumber(leaderboard[2]!.totalInvest)}",
                        image: leaderboard[2]!.profileImg != "Unknown"
                            ? leaderboard[2]!.profileImg
                            : AppImagePath.profileImage,
                        rankColor: AppColors.orange,
                        avatarSize: 40,
                      ),
                    ),
                  ),
              ],
            ),
          ),
  
              
          Expanded(
            child: leaderboard.isEmpty
                ? Center(
                    child: Container(
                      color: AppColors.blueDark,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time_outlined, color: AppColors.white, size: 100),
                          // SpaceWidget(spaceHeight: 20),
                          TextWidget(text: "Coming Soon", fontColor: AppColors.white),
                          // IconWidget(height: 100, width: 100, icon: AppIconPath.timeLeft)
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      onRefresh();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final data = filteredList[index]!;
                        final fromNetwork = data.profileImg != "Unknown";
                        return LeaderboardItem(
                          key: ValueKey('${data.name}${data.currentRank}$index'),
                          shoutTitle: data.shoutTitle,
                          rank: data.currentRank.toString(),
                          name: data.name,
                          amount: "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
                          isUp: (data.previousRank - data.currentRank) > 0,
                          fromNetwork: fromNetwork,
                          image: fromNetwork
                              ? "${AppUrls.mainUrl}${data.profileImg}"
                              : AppImagePath.profileImage,
                          backgrounColor: data.userId == myData?.userId ? AppColors.midblue : null,
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.otherProfileScreen,
                              arguments: data.userId,
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
                      
          if (showSelf) _selfRank(myIndex, showFloating, Get.find<LeaderboardController>()),
                  
            
          // ...List.generate(filteredList.length, (index) {
          //   final data = filteredList[index]!;
          //   final fromNetwork = data.profileImg != "Unknown";
          //   return LeaderboardItem(
          //     key: ValueKey('${data.name}${data.currentRank}$index'),
          //     rank: data.currentRank,
          //     name: data.name,
          //     amount: "\$${data.totalInvest}",
          //     isUp: (data.previousRank - data.currentRank) > 0,
          //     fromNetwork: fromNetwork,
          //     image: fromNetwork
          //         ? "${AppUrls.mainUrl}${data.profileImg}"
          //         : AppImagePath.profileImage,
          //     onPressed: () {
          //       Get.to(OtherProfileScreen(userId: data.userId));
          //     },
          //   );
          // }),
        ],
      );
    } catch (e) {
      appLog(e);
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time_outlined, color: AppColors.white, size: 100),
            SpaceWidget(spaceHeight: 20),
            TextWidget(text: "Coming Soon", fontColor: AppColors.white),
            // IconWidget(height: 100, width: 100, icon: AppIconPath.timeLeft)
          ],
        ),
      );
    }
  }

  Widget _selfRank(int myIndex, bool showFloating, LeaderboardController controller) {
    return Obx(() {
      int rank = 0;
      LeaderBoardModel? myData;
      if (controller.leaderboardTime.value == LeaderboardTime.allTime &&
          controller.leaderBoardList.isNotEmpty) {
        rank = controller.leaderBoardList
            .indexWhere((element) => element?.userId == StorageService.userId);
        if (rank != -1) {
          myData = controller.leaderBoardList[rank];
        }
      } else if (controller.leaderboardTime.value == LeaderboardTime.daily &&
          controller.leaderBoardDailyList.isNotEmpty) {
        rank = controller.leaderBoardDailyList
            .indexWhere((element) => element?.userId == StorageService.userId);
        if (rank != -1) {
          myData = controller.leaderBoardDailyList[rank];
        }
      } else if (controller.leaderboardTime.value == LeaderboardTime.monthly &&
          controller.leaderBoardMonthlyList.isNotEmpty) {
        rank = controller.leaderBoardMonthlyList
            .indexWhere((element) => element?.userId == StorageService.userId);
        if (rank != -1) {
          myData = controller.leaderBoardMonthlyList[rank];
        }
      }

      return Container(
        color: AppColors.blue,
        child: LeaderboardItem(
          key: ValueKey(
            '${myData?.name ?? 'N/A'}${myData?.currentRank ?? 'N/A'}$rank',
          ),
          rank: myData?.currentRank == 0 || myData == null ? 'N/A' : '${myData.currentRank}',
          name: StorageService.myName,
          amount:
              "\$${myData?.totalInvest != null ? AppCommonFunction.formatNumber(myData?.totalInvest) : 'N/A'}",
          isUp: showFloating && myData != null && myIndex != -1
              ? (myData.previousRank - myData.currentRank) > 0
              : false,
          fromNetwork: myData?.profileImg != "Unknown",
          image: '${AppUrls.mainUrl}${Get.find<ProfileScreenController>().image.value}',
          shoutTitle: myData?.shoutTitle ?? '',
          onPressed: () {
            Get.toNamed(
              AppRoutes.otherProfileScreen,
              arguments: myData?.userId ?? StorageService.userId,
            );
          },
        ),
      );
    });
  }
}
