import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/models/leader_board_model_raised.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/country_leaderboard_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/floating_button_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_dropdown.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_tabbar.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/screens/other_profile_screen/other_profile_screen.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_image_path.dart';
import '../../routes/app_routes.dart';
import '../../widgets/icon_widget/icon_widget.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

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
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _controller.fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildLeaderboardTabView(List<LeaderBoardModel?> leaderboard) {
    try {
      final filteredList = leaderboard.skip(3).where((e) => e != null).toList();

      final myData = filteredList.firstWhere(
        (element) => element!.userId == _controller.userId.value,
        orElse: () => LeaderBoardModel.empty(),
      );
      final myIndex = filteredList.indexWhere(
        (element) => element?.userId == _controller.userId.value,
      );
      bool showFloating = true;
      appLog("myIndex is: $myIndex");
      if (leaderboard.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_outlined,
                  color: AppColors.white, size: 100),
              SpaceWidget(spaceHeight: 20),
              TextWidget(text: "Coming Soon", fontColor: AppColors.white),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                        fromOnline: leaderboard[1]!.profileImg != "Unknown",
                        rankLabel: leaderboard[1]!.currentRank.toString(),
                        name: leaderboard[1]!.name,
                        amount:
                            "\$${AppCommonFunction.formatNumber(leaderboard[1]!.totalInvest)}",
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
                      final userId = leaderboard[0]!.userId;
                      Get.toNamed(
                        AppRoutes.otherProfileScreen,
                        arguments: userId,
                      );
                    },
                    child: Transform.translate(
                      offset: const Offset(0, -10),
                      child: TopRankedItem(
                        fromOnline: leaderboard[0]!.profileImg != "Unknown",
                        rankLabel: leaderboard[0]!.currentRank.toString(),
                        name: leaderboard[0]!.name,
                        amount:
                            "\$${AppCommonFunction.formatNumber(leaderboard[0]!.totalInvest)}",
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
                        fromOnline: leaderboard[2]!.profileImg != "Unknown",
                        rankLabel: leaderboard[2]!.currentRank.toString(),
                        name: leaderboard[2]!.name,
                        amount:
                            "\$${AppCommonFunction.formatNumber(leaderboard[2]!.totalInvest)}",
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
            child: Stack(
              children: [
                NotificationListener<ScrollNotification>(
                  key: ValueKey(myIndex.toString()),
                  onNotification: (scrollNotification) {
                    final scrollOffset = scrollNotification.metrics.pixels;
                    final screenHeight =
                        scrollNotification.metrics.viewportDimension;

                    final itemTop = myIndex * _controller.eachItemHeight;
                    final itemBottom = itemTop + _controller.eachItemHeight;

                    final visibleTop = scrollOffset;
                    final visibleBottom = scrollOffset + screenHeight;

                    final isInView =
                        itemBottom >= visibleTop && itemTop <= visibleBottom;

                    if (isInView && showFloating) {
                      showFloating = false;
                    } else if (!isInView && !showFloating) {
                      showFloating = true;
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _controller.fetchData();
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller.scrollController,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final data = filteredList[index]!;
                        final fromNetwork = data.profileImg != "Unknown";
                        return LeaderboardItem(
                          key:
                              ValueKey('${data.name}${data.currentRank}$index'),
                          rank: data.currentRank,
                          name: data.name,
                          amount:
                              "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
                          isUp: (data.previousRank - data.currentRank) > 0,
                          fromNetwork: fromNetwork,
                          image: fromNetwork
                              ? "${AppUrls.mainUrl}${data.profileImg}"
                              : AppImagePath.profileImage,
                          backgrounColor: data.userId == myData?.userId
                              ? AppColors.midblue
                              : null,
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
                              '${myData.name}${myData.currentRank}$myIndex',
                            ),
                            rank: myData.currentRank,
                            name: myData.name,
                            amount:
                                "\$${AppCommonFunction.formatNumber(myData.totalInvest)}",
                            isUp:
                                (myData.previousRank - myData.currentRank) > 0,
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

  Widget buildLeaderboardRaisedTabView(
    List<LeaderBoardModelRaised?> leaderboard,
  ) {
    try {
      appLog("The raised data: ${leaderboard.length}");
      final filteredList = leaderboard.skip(3).where((e) => e != null).toList();

      final myData = filteredList.firstWhere(
        (element) => element!.userId == _controller.userId.value,
        orElse: () => LeaderBoardModelRaised.empty(),
      );
      final myIndex = filteredList.indexWhere(
        (element) => element?.userId == _controller.userId.value,
      );
      bool showFloating = true;
      appLog("myIndex is: $myIndex, leaderboard length: ${leaderboard.length}");
      if (leaderboard.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time_outlined,
                  color: AppColors.white, size: 100),
              SpaceWidget(spaceHeight: 20),
              TextWidget(text: "Coming Soon", fontColor: AppColors.white),
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
                        fromOnline: leaderboard[1]!.profileImg != "Unknown",
                        rankLabel: "${leaderboard[1]?.currentRaisedRank}",
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
                        fromOnline: leaderboard[0]!.profileImg != "Unknown",
                        rankLabel: leaderboard[0]!.currentRaisedRank.toString(),
                        name: leaderboard[0]!.name,
                        amount:
                            "\$${AppCommonFunction.formatNumber(leaderboard[0]!.totalRaised)}",
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
                        fromOnline: leaderboard[2]!.profileImg != "Unknown",
                        rankLabel: leaderboard[2]!.currentRaisedRank.toString(),
                        name: leaderboard[2]!.name,
                        amount:
                            "\$${AppCommonFunction.formatNumber(leaderboard[2]!.totalRaised)}",
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
                      final screenHeight =
                          scrollNotification.metrics.viewportDimension;

                      final itemTop = myIndex * _controller.eachItemHeight;
                      final itemBottom = itemTop + _controller.eachItemHeight;

                      final visibleTop = scrollOffset;
                      final visibleBottom = scrollOffset + screenHeight;

                      final isInView =
                          itemBottom >= visibleTop && itemTop <= visibleBottom;

                      if (isInView && showFloating) {
                        showFloating = false;
                      } else if (!isInView && !showFloating) {
                        showFloating = true;
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _controller.fetchData();
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _controller.scrollController,
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final data = filteredList[index]!;
                          final fromNetwork = data.profileImg != "Unknown";
                          return LeaderboardItem(
                            key: ValueKey(
                              '${data.name}${data.currentRaisedRank}$index',
                            ),
                            rank: data.currentRaisedRank,
                            name: data.name,
                            amount:
                                "\$${AppCommonFunction.formatNumber(data.totalRaised)}",
                            isUp: (data.previousRaisedRank -
                                    data.currentRaisedRank) >
                                0,
                            fromNetwork: fromNetwork,
                            image: fromNetwork
                                ? "${AppUrls.mainUrl}${data.profileImg}"
                                : AppImagePath.profileImage,
                            backgrounColor: data.userId == myData?.userId
                                ? AppColors.midblue
                                : null,
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
                              rank: myData.currentRaisedRank,
                              name: myData.name,
                              amount:
                                  "\$${AppCommonFunction.formatNumber(myData.totalRaised)}",
                              isUp: (myData.previousRaisedRank -
                                      myData.currentRaisedRank) >
                                  0,
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(
          () => SafeArea(
            child: _controller.isLoading.value ||
                    _controller.isLoadingCountry.value ||
                    _controller.isLoadingCreator.value ||
                    _controller.isLoadingToday.value ||
                    _controller.isLoadingMonthly.value ||
                    _controller.isLoadingCreatorToday.value ||
                    _controller.isLoadingCreatorMonthly.value ||
                    _controller.isLoadingCountryToday.value ||
                    _controller.isLoadingCountryMonthly.value
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Stack(
                    children: [
                      const Positioned(
                          bottom: 90, right: 20, child: FloatingButtonWidget()),
                      Column(
                        children: [
                          const SpaceWidget(spaceHeight: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
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
                                        AppColors.white.withOpacity(
                                      0.15,
                                    ),
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
                                  buildLeaderboardTabView(
                                    _controller.leaderBoardList,
                                  )
                                else if (selectedLeaderboard ==
                                    'Event Leaderboard')
                                  CountryLeaderboardWidget(
                                    controller: _controller,
                                    leaderboard: _controller.countryList,
                                  )
                                else
                                  buildLeaderboardRaisedTabView(
                                      _controller.creatorList),
                                // Daily Tab
                                if (selectedLeaderboard == 'Leaderboard')
                                  buildLeaderboardTabView(
                                    _controller.leaderBoardDailyList,
                                  )
                                else if (selectedLeaderboard ==
                                    'Event Leaderboard')
                                  CountryLeaderboardWidget(
                                    controller: _controller,
                                    leaderboard: _controller.countryDailyList,
                                  )
                                else
                                  buildLeaderboardRaisedTabView(
                                      _controller.creatorDailyList),
                                // Monthly Tab
                                if (selectedLeaderboard == 'Leaderboard')
                                  buildLeaderboardTabView(
                                    _controller.leaderBoardMonthlyList,
                                  )
                                else if (selectedLeaderboard ==
                                    'Event Leaderboard')
                                  CountryLeaderboardWidget(
                                    controller: _controller,
                                    leaderboard: _controller.countryMonthlyList,
                                  )
                                else
                                  buildLeaderboardRaisedTabView(
                                    _controller.creatorMonthlyList,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
