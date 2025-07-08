import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/constants/app_strings.dart';
import 'package:the_leaderboard/screens/home_screen/controller/home_screen_controller.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/hall_of_fame_card_widget.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/home_appbar_widget.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/profile_card_widget.dart';
import 'package:the_leaderboard/screens/home_screen/widgets/recent_activity_card_widget.dart';
import 'package:the_leaderboard/widgets/image_widget/image_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_icon_path.dart';
import '../../routes/app_routes.dart';
import '../../widgets/icon_widget/icon_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = Get.put(HomeScreenController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchData();
  }

  final List<String> title = [
    AppStrings.recordSingle,
    AppStrings.consistentlyTop,
    AppStrings.mostEngage,
  ];

  final List<String> name = [
    'Anderson',
    'Anderson',
    'Eduardo',
  ];

  final List<String> imageUrl = [
    AppImagePath.highestPaymentImage,
    AppImagePath.consistentlyTopImage,
    AppImagePath.mostEngagedProfileImage,
  ];

  final List<String> type = [
    AppStrings.highestPayment,
    AppStrings.consecutively1st,
    AppStrings.mostViewedProfile,
  ];

  final List<String> status = [
    "\$ 34,535",
    "Last 30 Days",
    "5,533 Views",
  ];

//
  final List<String> actions = const [
    'JAMIE LEE',
    'JAMIE LEE',
    'JAMIE LEE',
    'JAMIE LEE',
    'JAMIE LEE',
    'JAMIE LEE',
  ];

  final List<String> values = const [
    'SPENT \$50',
    'WON 150 TICKETS',
    'WON 400 TICKETS',
    'SPENT \$50',
    'WON 150 TICKETS',
    'WON 400 TICKETS',
  ];

  final List<String> times = const [
    '2 min ago',
    '12 min ago',
    '12 min ago',
    '2 min ago',
    '12 min ago',
    '12 min ago',
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar: HomeAppbarWidget(
          title: AppStrings.theLeaderboard,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: ImageWidget(
              height: 20,
              width: 20,
              imagePath: AppImagePath.crownImage,
              fit: BoxFit.contain,
            ),
          ),
          action: IconButton(
            tooltip: "Notifications",
            onPressed: () {
              Get.toNamed(AppRoutes.notificationsScreen);
            },
            icon: const Badge(
              isLabelVisible: true,
              label: Text('3'),
              backgroundColor: AppColors.red,
              child: IconWidget(
                icon: AppIconPath.notificationIcon,
                width: 24,
                height: 24,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceWidget(spaceHeight: 16),
                _controller.ismydataLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ProfileCardWidget(
                        profileImagePath: AppImagePath.profileImage,
                        name: _controller.name.value,
                        rankNumber: _controller.rank.value,
                        totalRaisedAmount: "\$${_controller.totalRaised.value}",
                        totalSpentAmount: "\$${_controller.totalSpent.value}",
                        onViewProfilePressed: _controller.viewMyProfile,
                        onJoinLeaderboardPressed: () {},
                        onSharePressed: () {},
                      ),
                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextWidget(
                    text: AppStrings.hallOfFame,
                    fontColor: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SpaceWidget(spaceHeight: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _controller.ishallofframeSinglePaymentLoading.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : HallOfFameCardWidget(
                                name: _controller
                                    .recoredSinglePayment.value!.name,
                                status:
                                    "\$${_controller.recoredSinglePayment.value!.totalInvested}",
                                imageUrl: '',
                                type: AppStrings.highestPayment,
                                title: AppStrings.recordSingle,
                              ),
                        _controller.ishallofframeConsisntantTopLoading.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : HallOfFameCardWidget(
                                name: _controller.consistantlyTop.value!.name,
                                status:
                                    "Last ${_controller.consistantlyTop.value!.timesRankedTop} Days",
                                imageUrl: '',
                                type: AppStrings.consecutively1st,
                                title: AppStrings.consistentlyTop,
                              ),
                        _controller.ishallofframeMostEngagedLoading.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : HallOfFameCardWidget(
                                imageUrl:
                                    _controller.mostEngaged.value!.profileImg,
                                name: _controller.mostEngaged.value!.name,
                                status:
                                    "${_controller.mostEngaged.value!.views} Views",
                                type: AppStrings.mostViewedProfile,
                                title: AppStrings.mostEngage,
                              )
                      ]),
                ),
                const SpaceWidget(spaceHeight: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextWidget(
                    text: AppStrings.recentActivity,
                    fontColor: AppColors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SpaceWidget(spaceHeight: 8),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Get screen height safely
                    final screenHeight = MediaQuery.of(context).size.height;
                    // Calculate a safe height value (190 or 25% of screen height)
                    final containerHeight = screenHeight * 0.25;

                    return Container(
                      width: double.infinity,
                      height: containerHeight,
                      // Use safe height value
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: 
                      SingleChildScrollView(
                        child: Column(
                          children: List.generate(actions.length, (index) {
                            return RecentActivityCardWidget(
                              action: actions[index],
                              value: values[index],
                              time: times[index],
                            );
                          }),
                        ),
                      ),
                      // StreamBuilder(stream: _controller.streamSocket.getResponse, builder: (context, snapshot) {
                      //   if(snapshot.hasData){
                      //     return ListView.builder(itemBuilder: (context, index) => RecentActivityCardWidget(action: snapshot.data[index], value: value, time: time),)
                      //   }
                      // },)
                    );
                  },
                ),
                const SpaceWidget(spaceHeight: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
