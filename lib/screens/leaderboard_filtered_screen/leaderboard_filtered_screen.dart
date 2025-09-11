import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_dropdown.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_item.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/leaderboard_filtered_tabbar.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/widgets/top_rank_filtered_item.dart';
import 'package:the_leaderboard/screens/other_profile_screen/other_profile_screen.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/widgets/appbar_widget/appbar_widget.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class LeaderboardFilteredScreen extends StatefulWidget {
  const LeaderboardFilteredScreen(
      {super.key,
      required this.leaderBoardList,
      required this.countryList,
      required this.creatorList,
      required this.isLoading});
  final List<LeaderBoardModel?> leaderBoardList;
  final List<LeaderBoardModel?> countryList;
  final List<LeaderBoardModel?> creatorList;

  final bool isLoading;
  @override
  _LeaderboardFilteredScreenState createState() =>
      _LeaderboardFilteredScreenState();
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

  Widget buildLeaderboardTabView(List<LeaderBoardModel?> filterList) {
    final filteredList = filterList.where((e) => e!.currentRank > 4).toList();
    if (filterList.isEmpty) {
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
              text: "Coming Soon",
              fontColor: AppColors.white,
            ),
            // IconWidget(height: 100, width: 100, icon: AppIconPath.timeLeft)
          ],
        ),
      );
    }
    return Column(
      children: [
        const SpaceWidget(spaceHeight: 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (widget.leaderBoardList.length > 1)
              InkWell(
                onTap: () {
                  final userid = filterList[1]!.userId;
                  Get.to(OtherProfileScreen(userId: userid));
                },
                child: Transform.translate(
                  offset: Offset.zero,
                  child: TopRankedItem(
                      fromNetwork: filterList[1]!.profileImg != "Unknown",
                      rankLabel: filterList[1]!.currentRank.toString(),
                      name: filterList[1]!.name,
                      amount:
                          "\$${AppCommonFunction.formatNumber(widget.leaderBoardList[1]!.totalInvest)}",
                      image: filterList[1]!.profileImg != "Unknown"
                          ? "${AppUrls.mainUrl}${widget.leaderBoardList[1]!.profileImg}"
                          : AppImagePath.profileImage,
                      rankColor: AppColors.greyDark,
                      avatarSize: 40),
                ),
              ),
            InkWell(
              onTap: () {
                final userId = filterList[0]!.userId;
                Get.to(OtherProfileScreen(userId: userId));
              },
              child: Transform.translate(
                offset: const Offset(0, -10),
                child: TopRankedItem(
                    fromNetwork: filterList[0]!.profileImg != "Unknown",
                    rankLabel: filterList[0]!.currentRank.toString(),
                    name: filterList[0]!.name,
                    amount:
                        "\$${AppCommonFunction.formatNumber(widget.leaderBoardList[0]!.totalInvest)}",
                    image: filterList[0]!.profileImg != "Unknown"
                        ? "${AppUrls.mainUrl}${widget.leaderBoardList[0]!.profileImg}"
                        : AppImagePath.profileImage,
                    rankColor: AppColors.yellow,
                    avatarSize: 55),
              ),
            ),
            if (widget.leaderBoardList.length > 2)
              InkWell(
                onTap: () {
                  final userId = filterList[2]!.userId;
                  Get.to(OtherProfileScreen(userId: userId));
                },
                child: Transform.translate(
                  offset: Offset.zero,
                  child: TopRankedItem(
                      fromNetwork: filterList[2]!.profileImg != "Unknown",
                      rankLabel: filterList[2]!.currentRank.toString(),
                      name: filterList[2]!.name,
                      amount:
                          "\$${AppCommonFunction.formatNumber(widget.leaderBoardList[2]!.totalInvest)}",
                      image: filterList[2]!.profileImg != "Unknown"
                          ? "${AppUrls.mainUrl}${widget.leaderBoardList[2]!.profileImg}"
                          : AppImagePath.profileImage,
                      rankColor: AppColors.orange,
                      avatarSize: 40),
                ),
              ),
          ]),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final data = filteredList[index];
              return LeaderboardItem(
                key: ValueKey('${data!.name}${data.currentRank}$index'),
                rank: data.currentRank,
                name: data.name,
                amount: "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
                isUp: (data.previousRank - data.currentRank) > 0 ? true : false,
                image: data.profileImg != "Unknown"
                    ? "${AppUrls.mainUrl}${data.profileImg}"
                    : AppImagePath.profileImage,
                onPressed: () {
                  Get.to(OtherProfileScreen(userId: data.userId));
                },
              );
            },
          ),
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
    return Scaffold(
      appBar: const AppbarWidget(
        title: "",
      ),
      body: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: widget.isLoading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      const SpaceWidget(spaceHeight: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: LeaderboardDropdown(
                          value: selectedLeaderboard,
                          text: const [
                            'Leaderboard',
                            'Event Leaderboard',
                            'Creator Leaderboard',
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedLeaderboard = value!;
                              _tabController.index = 0;
                            });
                          },
                        ),
                      ),

                      // Replaced TabBar with LeaderboardTabBar
                      LeaderboardTabBar(
                        tabTexts: const ['All Time', 'Daily', 'Monthly'],
                        tabController: _tabController,
                      ),

                      // TabBarView
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // All Time Tab
                            if (selectedLeaderboard == 'Leaderboard')
                              buildLeaderboardTabView(widget.leaderBoardList)
                            else if (selectedLeaderboard == 'Event Leaderboard')
                              buildLeaderboardTabView(widget.countryList)
                            else
                              buildLeaderboardTabView(widget.creatorList),
                            // Daily Tab
                            if (selectedLeaderboard == 'Leaderboard')
                              buildLeaderboardTabView(widget.leaderBoardList)
                            else if (selectedLeaderboard == 'Event Leaderboard')
                              buildLeaderboardTabView(widget.countryList)
                            else
                              buildLeaderboardTabView(widget.creatorList),
                            // Monthly Tab
                            if (selectedLeaderboard == 'Leaderboard')
                              buildLeaderboardTabView(widget.leaderBoardList)
                            else if (selectedLeaderboard == 'Event Leaderboard')
                              buildLeaderboardTabView(widget.countryList)
                            else
                              buildLeaderboardTabView(widget.creatorList),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
