import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_dropdown.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_tabbar.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/screens/other_profile_screen/other_profile_screen.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_path.dart';
import '../../routes/app_routes.dart';
import '../../widgets/icon_widget/icon_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
  });

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  String selectedLeaderboard = 'Leaderboard';
  late TabController _tabController;
  final _controller = Get.put(LeaderboardController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller.fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildLeaderboardTabView() {
    final filteredList =
        _controller.leaderBoardList.where((e) => e!.currentRank > 4).toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          const SpaceWidget(spaceHeight: 20),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (_controller.leaderBoardList.length > 1)
                    InkWell(
                      onTap: () {
                        final userid = _controller.leaderBoardList[1]?.userId;
                        Get.to(OtherProfileScreen(userId: userid!));
                      },
                      child: Transform.translate(
                        offset: Offset.zero,
                        child: TopRankedItem(
                            fromOnline: _controller.leaderBoardList[1]!.profileImg != "Unknown",
                            rankLabel: _controller
                                .leaderBoardList[1]!.currentRank
                                .toString(),
                            name: _controller.leaderBoardList[1]!.name,
                            amount:
                                "\$${_controller.leaderBoardList[1]!.totalInvest}",
                            image: _controller.leaderBoardList[1]!.profileImg !=
                                    "Unknown"
                                ? "${AppUrls.mainUrl}${_controller.leaderBoardList[1]!.profileImg}"
                                : AppImagePath.profileImage,
                            rankColor: AppColors.greyDark,
                            avatarSize: 40),
                      ),
                    ),
                  InkWell(
                    onTap: () {
                      final userId = _controller.leaderBoardList[0]!.userId;
                      Get.to(OtherProfileScreen(userId: userId));
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -10),
                      child: TopRankedItem(
                        fromOnline: _controller.leaderBoardList[0]!.profileImg != "Unknown",
                          rankLabel: _controller.leaderBoardList[0]!.currentRank
                              .toString(),
                          name: _controller.leaderBoardList[0]!.name,
                          amount:
                              "\$${_controller.leaderBoardList[0]!.totalInvest}",
                          image: _controller.leaderBoardList[0]!.profileImg !=
                                  "Unknown"
                              ? _controller.leaderBoardList[0]!.profileImg
                              : AppImagePath.profileImage,
                          rankColor: AppColors.yellow,
                          avatarSize: 55),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final userId = _controller.leaderBoardList[2]!.userId;
                      Get.to(OtherProfileScreen(userId: userId));
                    },
                    child: Transform.translate(
                      offset: Offset.zero,
                      child: TopRankedItem(
                        fromOnline: _controller.leaderBoardList[2]!.profileImg != "Unknown",
                          rankLabel: _controller.leaderBoardList[2]!.currentRank
                              .toString(),
                          name: _controller.leaderBoardList[2]!.name,
                          amount:
                              "\$${_controller.leaderBoardList[2]!.totalInvest}",
                          image: _controller.leaderBoardList[2]!.profileImg !=
                                  "Unknown"
                              ? _controller.leaderBoardList[2]!.profileImg
                              : AppImagePath.profileImage,
                          rankColor: AppColors.orange,
                          avatarSize: 40),
                    ),
                  ),
                ]),
          ),
          ...List.generate(
            filteredList.length,
            (index) {
              final data = filteredList[index];
              return LeaderboardItem(
                key: ValueKey('${data!.name}${data.currentRank}$index'),
                rank: data.currentRank,
                name: data.name,
                amount: "\$${data.totalInvest.toString()}",
                isUp: (data.previousRank - data.currentRank) > 0 ? true : false,
                image: data.profileImg != "Unknown"
                    ? data.profileImg
                    : AppImagePath.profileImage,
                onPressed: () {
                  Get.to(OtherProfileScreen(userId: data.userId));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        body: Obx(
          () => SafeArea(
            child: _controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      const SpaceWidget(spaceHeight: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Dropdown Button
                            LeaderboardDropdown(
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
                            // Search Icon
                            InkWell(
                              onTap: () {
                                Get.toNamed(AppRoutes.searchScreen);
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    AppColors.white.withOpacity(0.15),
                                child: const IconWidget(
                                  height: 22,
                                  width: 22,
                                  icon: AppIconPath.searchIcon,
                                ),
                              ),
                            ),
                          ],
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
                              buildLeaderboardTabView()
                            else if (selectedLeaderboard == 'Event Leaderboard')
                              buildLeaderboardTabView()
                            else
                              buildLeaderboardTabView(),
                            // Daily Tab
                            if (selectedLeaderboard == 'Leaderboard')
                              buildLeaderboardTabView()
                            else if (selectedLeaderboard == 'Event Leaderboard')
                              buildLeaderboardTabView()
                            else
                              buildLeaderboardTabView(),
                            // Monthly Tab
                            if (selectedLeaderboard == 'Leaderboard')
                              buildLeaderboardTabView()
                            else if (selectedLeaderboard == 'Event Leaderboard')
                              buildLeaderboardTabView()
                            else
                              buildLeaderboardTabView(),
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
