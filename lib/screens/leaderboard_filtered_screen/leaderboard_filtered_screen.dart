import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_tabbar.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/country_leaderboard_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_creator_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/screens/search_screen/controller/search_screen_controller.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';

class LeaderboardFilteredScreen extends StatelessWidget {
  const LeaderboardFilteredScreen({super.key});

  String getTitle(SearchScreenController controller) {
    String title = "";
    switch (controller.leaderboardType.value) {
      case LeaderboardType.leaderboard:
        title = "Leaderboard";
        break;
      case LeaderboardType.eventLeaderboard:
        title = "Event Leaderboard";
        break;
      case LeaderboardType.creatorLeaderboard:
        title = "Creator Leaderboard";
        break;
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SearchScreenController>().search();
    });
    return GetBuilder<SearchScreenController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppbarWidget(
            title: getTitle(controller),
            backgroundColor: AppColors.blueDark,
            onPress: () {
              controller.leaderboardTime.value = LeaderboardTime.allTime;
              controller.tabController.index = 0;
              controller.clearSearchResult();
            },
          ),
          backgroundColor: Colors.black,
          body: SafeArea(
              child: Stack(
            children: [
              Column(
                children: [
                  const SpaceWidget(spaceHeight: 8),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      
                      controller: controller.nameController,
                      style: const TextStyle(color: AppColors.white),
                      onChanged: (value) {
                        controller.search();
                   
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppColors.greyDarker,
                        ),
                        hintText: 'Search by name',
                        hintStyle: const TextStyle(
                          color: AppColors.greyDarker,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: AppColors.blue,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SpaceWidget(spaceHeight: 8),
                  LeaderboardTabBar(
                    tabTexts: const ['All Time', 'Daily', 'Monthly'],
                    tabController: controller.tabController,
                  ),
                  if (controller.isLoading.value)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 1.5,
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.blueDarker,
                          color: AppColors.deepBlue,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                  Expanded(
                    child: Obx(() => TabBarView(
                          controller: controller.tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildLeaderboardTabView(controller, LeaderboardTime.allTime),
                            _buildLeaderboardTabView(controller, LeaderboardTime.daily),
                            _buildLeaderboardTabView(controller, LeaderboardTime.monthly),
                          ],
                        )),
                  ),
                ],
              ),
            ],
          )),
        );
      },
    );
  }

  Widget _buildLeaderboardTabView(SearchScreenController controller, LeaderboardTime timePeriod) {
    if (timePeriod == LeaderboardTime.allTime) {
      if (controller.leaderboardType.value == LeaderboardType.leaderboard) {
        return LeaderboardWidget(
          showSelf: false,
          leaderboard: controller.leaderBoardList,
          onRefresh: controller.search,
          scrollController: controller.scrollController,
        );
      } else if (controller.leaderboardType.value == LeaderboardType.eventLeaderboard) {
        return CountryLeaderboardWidget(
          leaderboard: controller.countryList,
          onRefresh: controller.search,
        );
      } else {
        return LeaderboardCreatorWidget(
          leaderboard: controller.creatorList,
          onRefresh: controller.search,
          scrollController: controller.scrollController,
        );
      }
    } else if (timePeriod == LeaderboardTime.daily) {
      if (controller.leaderboardType.value == LeaderboardType.leaderboard) {
        return LeaderboardWidget(
          showSelf: false,
          leaderboard: controller.leaderBoardDailyList,
          onRefresh: controller.search,
          scrollController: controller.scrollController,
        );
      } else if (controller.leaderboardType.value == LeaderboardType.eventLeaderboard) {
        return CountryLeaderboardWidget(
          leaderboard: controller.countryDailyList,
          onRefresh: controller.search,
        );
      } else {
        return LeaderboardCreatorWidget(
          leaderboard: controller.creatorDailyList,
          onRefresh: controller.search,
          scrollController: controller.scrollController,
        );
      }
    } else {
      if (controller.leaderboardType.value == LeaderboardType.leaderboard) {
        return LeaderboardWidget(
          showSelf: false,
          leaderboard: controller.leaderBoardMonthlyList,
          onRefresh: controller.search,
          scrollController: controller.scrollController,
        );
      } else if (controller.leaderboardType.value == LeaderboardType.eventLeaderboard) {
        return CountryLeaderboardWidget(
          leaderboard: controller.countryMonthlyList,
          onRefresh: controller.search,
        );
      } else {
        return LeaderboardCreatorWidget(
          leaderboard: controller.creatorMonthlyList,
          onRefresh: controller.search,
          scrollController: controller.scrollController,
        );
      }
    }
  }

  Widget _buildLeaderboardList(
      SearchScreenController controller, List<LeaderBoardModel> participants) {
    if (participants.isEmpty) {
      return _buildEmptyState("No participants found");
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) => false,
      child: RefreshIndicator(
        onRefresh: controller.search,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: controller.scrollController,
          itemCount: participants.length,
          itemBuilder: (context, index) {
            final data = participants[index];
            final fromNetwork = data.profileImg != "Unknown";
            return LeaderboardItem(
              key: ValueKey('${data.name}${data.currentRank}$index'),
              rank: (index + 4).toString().padLeft(2, '0'),
              name: data.name,
              shoutTitle: data.shoutTitle,
              amount: "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
              isUp: data.previousRank > data.currentRank,
              fromNetwork: fromNetwork,
              image:
                  fromNetwork ? "${AppUrls.mainUrl}${data.profileImg}" : AppImagePath.profileImage,
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
    );
  }

  Widget _buildTopRankedItem(
      LeaderBoardModel data, int rank, double dx, double dy, Color color, double size) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppRoutes.otherProfileScreen,
          arguments: data.userId,
        );
      },
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: TopRankedItem(
          fromOnline: data.profileImg != "Unknown",
          rankLabel: (rank + 1).toString(),
          name: data.name,
          amount: "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
          image: data.profileImg != "Unknown"
              ? "${AppUrls.mainUrl}${data.profileImg}"
              : AppImagePath.profileImage,
          rankColor: color,
          avatarSize: size,
        ),
      ),
    );
  }

  Widget _buildEmptyState([String message = "No data available"]) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events_outlined, color: AppColors.white, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.find<SearchScreenController>().search(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget buildLeaderboardTabView(
      SearchScreenController controller, List<LeaderBoardModel> leaderboard) {
    print('---Method depth 2----------${controller.countryList.length}');
    print('---Method depth 2----------${leaderboard.length}');

    if (leaderboard.isEmpty) {
      return _buildEmptyState();
    }

    final myIndex = leaderboard.indexWhere(
      (element) => element.userId == controller.userId,
    );
    appLog("myIndex is: $myIndex");

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Rank two
              if (leaderboard.length > 1)
                _buildTopRankedItem(leaderboard[1], 1, 0, 0, AppColors.greyDark, 40),

              // Rank one
              _buildTopRankedItem(leaderboard[0], 0, 0, -10, AppColors.yellow, 55),

              // Rank three or placeholder
              if (leaderboard.length > 2)
                _buildTopRankedItem(leaderboard[2], 2, 0, 0, AppColors.orange, 40)
              else if (leaderboard.length == 1)
                const SizedBox(width: 60), // Placeholder to maintain layout
            ],
          ),
        ),
        // Rest of the list
        if (leaderboard.length > 3)
          Expanded(
            child: _buildLeaderboardList(controller, leaderboard.sublist(3)),
          )
        else
          Expanded(
            child: _buildEmptyState("No more participants"),
          ),
      ],
    );
  }
}
