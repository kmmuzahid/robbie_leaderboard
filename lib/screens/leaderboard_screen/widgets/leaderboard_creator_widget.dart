import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model_raised.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class LeaderboardCreatorWidget extends StatelessWidget {
  const LeaderboardCreatorWidget(
      {super.key,
      required this.leaderboard,
      required this.onRefresh,
      required this.scrollController});
  final List<LeaderBoardModelRaised?> leaderboard;
  final Function() onRefresh;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return buildLeaderboardRaisedTabView(leaderboard);
  }

  Widget buildLeaderboardRaisedTabView(
    List<LeaderBoardModelRaised?> leaderboard,
  ) {
    try {
      appLog("The raised data: ${leaderboard.length}");
      final filteredList = leaderboard.skip(3).where((e) => e != null).toList();

      final myData = filteredList.firstWhere(
        (element) => element!.userId == StorageService.userId,
        orElse: () => LeaderBoardModelRaised.empty(),
      );
      final myIndex = filteredList.indexWhere(
        (element) => element?.userId == StorageService.userId,
      );
      bool showFloating = true;
      appLog("myIndex is: $myIndex, leaderboard length: ${leaderboard.length}");
      if (leaderboard.isEmpty) {
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
      return Column(
        children: [ 
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (leaderboard.length > 1)
                  InkWell(
                    onTap: () {
                      final userid = leaderboard[1]?.userId ?? "N/A";
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
                        rankLabel: leaderboard[1]!.currentRaisedRank.toString(),
                        name: leaderboard[1]!.name,
                        amount:
                            "\$${AppCommonFunction.formatNumber(leaderboard[1]?.totalRaised ?? 0)}",
                        image: leaderboard[1]!.profileImg != "Unknown"
                            ? leaderboard[1]!.profileImg
                            : AppImagePath.profileImage,
                        rankColor: AppColors.greyDark,
                        avatarSize: 40,
                      ),
                    ),
                  ),
                if (leaderboard.isNotEmpty)
                  InkWell(
                    onTap: () {
                      final userId = leaderboard[0]?.userId ?? "N/A";
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
                        rankLabel: leaderboard[0]!.currentRaisedRank.toString(),
                        name: leaderboard[0]!.name,
                        amount: "\$${AppCommonFunction.formatNumber(leaderboard[0]!.totalRaised)}",
                        image: leaderboard[0]!.profileImg != "Unknown"
                            ? leaderboard[0]!.profileImg
                            : AppImagePath.profileImage,
                        rankColor: AppColors.yellow,
                        avatarSize: 55,
                      ),
                    ),
                  ),
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
                        rankLabel: leaderboard[2]!.currentRaisedRank.toString(),
                        name: leaderboard[2]!.name,
                        amount: "\$${AppCommonFunction.formatNumber(leaderboard[2]!.totalRaised)}",
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
          if (filteredList.isNotEmpty)
            Expanded(
              child: Stack(
                children: [
                  NotificationListener<ScrollNotification>(
                    key: ValueKey(myIndex.toString()),
                    onNotification: (scrollNotification) {
                      final scrollOffset = scrollNotification.metrics.pixels;
                      final screenHeight = scrollNotification.metrics.viewportDimension;

                      final itemTop = myIndex * 50;
                      final itemBottom = itemTop + 50;

                      final visibleTop = scrollOffset;
                      final visibleBottom = scrollOffset + screenHeight;

                      final isInView = itemBottom >= visibleTop && itemTop <= visibleBottom;

                      if (isInView && showFloating) {
                        showFloating = false;
                      } else if (!isInView && !showFloating) {
                        showFloating = true;
                      }
                      return false;
                    },
                    child: RefreshIndicator(
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
                            key: ValueKey(
                              '${data.name}${data.currentRaisedRank}$index',
                            ),
                            rank: data.currentRaisedRank.toString(),
                            shoutTitle: myData?.shoutTitle ?? '',
                            name: data.name,
                            amount: "\$${AppCommonFunction.formatNumber(data.totalRaised)}",
                            isUp: (data.previousRaisedRank - data.currentRaisedRank) > 0,
                            fromNetwork: fromNetwork,
                            image: fromNetwork
                                ? "${AppUrls.mainUrl}${data.profileImg}"
                                : AppImagePath.profileImage,
                            backgrounColor:
                                data.userId == myData?.userId ? AppColors.midblue : null,
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
                  showFloating && myData != null && myIndex != -1
                      ? Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: AppColors.blue,
                            child: LeaderboardItem(
                              key: ValueKey(
                                '${myData.name}${myData.currentRaisedRank}$myIndex',
                              ),
                              rank: myData.currentRaisedRank.toString(),
                              name: myData.name,
                              shoutTitle: myData.shoutTitle,
                              amount:
                                  "\$${myData.totalRaised > 0 ? AppCommonFunction.formatNumber(myData.totalRaised) : 'N/A'}",
                              isUp: (myData.previousRaisedRank - myData.currentRaisedRank) > 0,
                              fromNetwork: myData.profileImg != "Unknown",
                              image: myData.profileImg != "Unknown"
                                  ? "${AppUrls.mainUrl}${myData.profileImg}"
                                  : AppImagePath.profileImage,
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.otherProfileScreen,
                                  arguments: myData.userId,
                                );
                              },
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
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
      appLog("the error: $e");
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
}
