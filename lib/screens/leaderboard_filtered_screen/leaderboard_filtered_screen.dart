import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/routes/app_routes.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_dropdown.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_item.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_tabbar.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/top_rank_filtered_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/floating_button_widget.dart';
import 'package:the_leaderboard/screens/other_profile_screen/other_profile_screen.dart';
import 'package:the_leaderboard/screens/search_screen/controller/search_screen_controller.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

import '../leaderboard_screen/widgets/leaderboard_item.dart';
import '../leaderboard_screen/widgets/top_rank_item.dart';

class LeaderboardFilteredScreen extends StatefulWidget {
  const LeaderboardFilteredScreen({
    super.key,
  });

  // final bool isLoading;
  @override
  _LeaderboardFilteredScreenState createState() => _LeaderboardFilteredScreenState();
}

class _LeaderboardFilteredScreenState extends State<LeaderboardFilteredScreen>
    with SingleTickerProviderStateMixin {
  String selectedLeaderboard = 'Leaderboard';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to safely get an item from a list or return null if index is out of bounds
  T? safeGet<T>(List<T?> list, int index) {
    return index < list.length ? list[index] : null;
  }

  // Helper method to build a ranked item widget
  Widget _buildRankedItem(
    List<LeaderBoardModel?> list,
    int index,
    double dx,
    double dy,
    Color rankColor,
    double avatarSize,
    SearchScreenController controller,
  ) {
    final user = safeGet(list, index);
    if (user == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.otherProfileScreen, arguments: user.userId);
      },
      child: Transform.translate(
        offset: Offset(dx, dy),
        child: TopRankedItem(
          fromOnline: user.profileImg != "Unknown",
          rankLabel: user.currentRank.toString(),
          name: user.name,
          amount: safeGet(controller.sLeaderBoardList, index)?.totalInvest != null
              ? "\$${AppCommonFunction.formatNumber(controller.sLeaderBoardList[index]!.totalInvest)}"
              : "\$0",
          image: user.profileImg != "Unknown" ? "${user.profileImg}" : AppImagePath.profileImage,
          rankColor: rankColor,
          avatarSize: avatarSize,
        ),
      ),
    );
  }

  Widget buildLeaderboardTabView(
      List<LeaderBoardModel?> filterList, SearchScreenController controller) {
    // Filter out null items and items with rank <= 4
    final filteredList = filterList.where((e) => e != null && e.currentRank > 4).toList();

    if (filteredList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time_outlined,
              color: AppColors.white,
              size: 100,
            ),
            SpaceWidget(
              spaceHeight: 20,
            ),
            TextWidget(
              text: "No results found",
              fontColor: AppColors.white,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              // First place (middle)
              if (filteredList.isNotEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child:
                      _buildRankedItem(filteredList, 0, 0, -10, AppColors.yellow, 55, controller),
                ),

              // Second place (left)
              if (filteredList.length > 1)
                Positioned(
                  left: 20,
                  bottom: 0,
                  child:
                      _buildRankedItem(filteredList, 1, 0, 0, AppColors.greyDark, 40, controller),
                ),

              // Third place (right)
              if (filteredList.length > 2)
                Positioned(
                  right: 20,
                  bottom: 0,
                  child: _buildRankedItem(filteredList, 2, 0, 0, AppColors.orange, 40, controller),
                ),
            ],
          ),
        ),
        Expanded(
          child: filteredList.isEmpty
              ? Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                )
              : filteredList.length > 3
                  ? ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final data = filteredList[index];
                        if (data == null) return const SizedBox.shrink();
                        print(data.profileImg);

                        return LeaderboardItem(
                          key: ValueKey('${data.name}${data.currentRank}$index'),
                          rank: (data.currentRank + 3).toString().padLeft(2, '0'),
                          name: data.name,
                          amount: "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
                          isUp: (data.previousRank - data.currentRank) > 0,
                          image: data.profileImg != "Unknown"
                              ? "${AppUrls.mainUrl}${data.profileImg}"
                              : AppImagePath.profileImage,
                          onPressed: () {
                            Get.toNamed(AppRoutes.otherProfileScreen, arguments: data.userId);
                          },
                          fromNetwork: data.profileImg != "Unknown",
                        );
                      },
                    )
                  : const SizedBox.shrink(),
        ),
        // ...List.generate(
        //   filteredList.length,
        //   (index) {
        //     final data = filteredList[index];
        //     return LeaderboardItem(
        //       key: ValueKey('${data!.name}${data.currentRank}$index'),
        //       rank: data.currentRank,
        //       name: data.name,
        //       amount: "\$${data.totalInvest.toString()}",
        //       isUp: (data.previousRank - data.currentRank) > 0 ? true : false,
        //       image: data.profileImg != "Unknown"
        //           ? "${AppUrls.mainUrl}${data.profileImg}"
        //           : AppImagePath.profileImage,
        //       onPressed: () {
        //         Get.to(OtherProfileScreen(userId: data.userId));
        //       },
        //     );
        //   },
        // ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchScreenController>(builder: (controller) {
      return Scaffold(
        floatingActionButton: const FloatingButtonWidget(),
        appBar: AppbarWidget(
          title: "",
          onPress: controller.clearSearch,
        ),
        body: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  // const SpaceWidget(spaceHeight: 16),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  //   child: LeaderboardDropdown(
                  //     value: selectedLeaderboard,
                  //     text: const [
                  //       'Leaderboard',
                  //       'Event Leaderboard',
                  //       'Creator Leaderboard',
                  //     ],
                  //     onChanged: (value) {
                  //       setState(() {
                  //         selectedLeaderboard = value!;
                  //         _tabController.index = 0;
                  //       });
                  //     },
                  //   ),
                  // ),

                  // Replaced TabBar with LeaderboardTabBar
                  LeaderboardTabBar(
                    tabTexts: const ['All Time', 'Daily', 'Monthly'],
                    tabController: _tabController,
                  ),

                  // TabBarView
                  Expanded(
                    child: _tabview(controller),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _tabview(SearchScreenController controller) {
    return TabBarView(
      controller: _tabController,
      physics: const BouncingScrollPhysics(),
      children: [
        // All Time Tab
        if (selectedLeaderboard == 'Leaderboard')
          controller.isLoadingLeaderBoardList.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sLeaderBoardList, controller)
        else if (selectedLeaderboard == 'Event Leaderboard')
          controller.isLoadingCountryList.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sCountryList, controller)
        else
          controller.isLoadingCreatorList.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sCreatorList, controller),
        // Daily Tab
        if (selectedLeaderboard == 'Leaderboard')
          controller.isLoadingLeaderBoardListDaily.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sLeaderBoardListDaily, controller)
        else if (selectedLeaderboard == 'Event Leaderboard')
          controller.isLoadingCountryListDaily.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sCountryListDaily, controller)
        else
          controller.isLoadingCreatorListDaily.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sCreatorListDaily, controller),
        // Monthly Tab
        if (selectedLeaderboard == 'Leaderboard')
          controller.isLoadingLeaderBoardListMonthly.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sLeaderBoardListMonthly, controller)
        else if (selectedLeaderboard == 'Event Leaderboard')
          controller.isLoadingCountryListMonthly.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sCountryListMonthly, controller)
        else
          controller.isLoadingCreatorListMonthly.value
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildLeaderboardTabView(controller.sCreatorListMonthly, controller),
      ],
    );
  }
}
