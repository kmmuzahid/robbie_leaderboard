import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:the_leaderboard/constants/app_icon_path.dart';
import 'package:the_leaderboard/constants/app_urls.dart';
import 'package:the_leaderboard/models/leader_board_model.dart';
import 'package:the_leaderboard/models/leader_board_model_raised.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/country_leaderboard_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/floating_button_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_creator_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_dropdown.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_tabbar.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/leaderboard_widget.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/screens/other_profile_screen/other_profile_screen.dart';
import 'package:the_leaderboard/screens/profile_screen/controller/profile_screen_controller.dart';
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

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  String selectedLeaderboard = 'Leaderboard';
  late TabController _tabController;
  final _controller = Get.put(LeaderboardController());
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      final time = _tabController.index == 0
          ? LeaderboardTime.allTime
          : _tabController.index == 1
              ? LeaderboardTime.daily
              : LeaderboardTime.monthly;
      _controller.onTypeChange(leaderboardTime: time);
    });
    _controller.fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            child: Stack(
              children: [
                // const Positioned(
                //     bottom: 90, right: 20, child: FloatingButtonWidget()),
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

                                if (value == 'Leaderboard') {
                                  _controller.onTypeChange(
                                    leaderboardType: LeaderboardType.leaderboard,
                                    leaderboardTime: LeaderboardTime.allTime,
                                  );
                                } else if (value == 'Event Leaderboard') {
                                  _controller.onTypeChange(
                                    leaderboardType: LeaderboardType.eventLeaderboard,
                                    leaderboardTime: LeaderboardTime.allTime,
                                  );
                                } else {
                                  _controller.onTypeChange(
                                    leaderboardType: LeaderboardType.creatorLeaderboard,
                                    leaderboardTime: LeaderboardTime.allTime,
                                  );
                                }

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
                              backgroundColor: AppColors.white.withOpacity(
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
                    _controller.isLoading.value ||
                            _controller.isLoadingCountry.value ||
                            _controller.isLoadingCreator.value ||
                            _controller.isLoadingToday.value ||
                            _controller.isLoadingMonthly.value ||
                            _controller.isLoadingCreatorToday.value ||
                            _controller.isLoadingCreatorMonthly.value ||
                            _controller.isLoadingCountryToday.value ||
                            _controller.isLoadingCountryMonthly.value
                        ? const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: SizedBox(
                              height: 1.5,
                              child: LinearProgressIndicator(
                                  backgroundColor: AppColors.blueDarker, color: AppColors.deepBlue),
                            ),
                          )
                        : const SizedBox.shrink(),
                    // TabBarView
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // All Time Tab
                          if (selectedLeaderboard == 'Leaderboard')
                            LeaderboardWidget(
                              leaderboard: _controller.leaderBoardList,
                              onRefresh: _controller.fetchData,
                              scrollController: _controller.scrollController,
                            )
                          else if (selectedLeaderboard == 'Event Leaderboard')
                            CountryLeaderboardWidget(
                              onRefresh: _controller.fetchData,
                              leaderboard: _controller.countryList,
                            )
                          else
                            LeaderboardCreatorWidget(
                              leaderboard: _controller.creatorList,
                              onRefresh: _controller.fetchData,
                              scrollController: _controller.scrollController,
                            ),


                          // Daily Tab
                          if (selectedLeaderboard == 'Leaderboard')
                            LeaderboardWidget(
                              leaderboard: _controller.leaderBoardDailyList,
                              onRefresh: _controller.fetchData,
                              scrollController: _controller.scrollController,
                            )
                          else if (selectedLeaderboard == 'Event Leaderboard')
                            CountryLeaderboardWidget(
                              onRefresh: _controller.fetchData,
                              leaderboard: _controller.countryDailyList,
                            )
                          else
                            LeaderboardCreatorWidget(
                              leaderboard: _controller.creatorDailyList,
                              onRefresh: _controller.fetchData,
                              scrollController: _controller.scrollController,
                            ),
                          // Monthly Tab
                          if (selectedLeaderboard == 'Leaderboard')
                            LeaderboardWidget(
                              leaderboard: _controller.leaderBoardMonthlyList,
                              onRefresh: _controller.fetchData,
                              scrollController: _controller.scrollController,
                            )
                          else if (selectedLeaderboard == 'Event Leaderboard')
                            CountryLeaderboardWidget(
                              onRefresh: _controller.fetchData,
                              leaderboard: _controller.countryMonthlyList,
                            )
                          else
                            LeaderboardCreatorWidget(
                              leaderboard: _controller.creatorMonthlyList,
                              onRefresh: _controller.fetchData,
                              scrollController: _controller.scrollController,
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
