import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/models/country_leaderboard_model.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/country_leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class CountryLeaderboardWidget extends StatelessWidget {
  const CountryLeaderboardWidget({super.key, required this.leaderboard});
  final List<CountryLeaderboardModel?> leaderboard;
  @override
  Widget build(BuildContext context) {
    final filteredList = leaderboard.skip(3).where((e) => e != null).toList();
    String userId = LocalStorage.userId;
    appLog("mydata");
    appLog(LocalStorage.userId);

    if (leaderboard.isEmpty) {
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
            if (leaderboard.length > 1)
              Transform.translate(
                offset: Offset.zero,
                child: TopRankedItem(
                    fromOnline:
                        false, //leaderboard[1]!.profileImg != "Unknown",
                    rankLabel: "2",
                    name: leaderboard[1]!.country.toUpperCase(),
                    amount: "\$${leaderboard[1]!.totalInvest}",
                    image: AppImagePath.profileImage,
                    rankColor: AppColors.greyDark,
                    avatarSize: 40),
              ),
            if (leaderboard.isNotEmpty)
              Transform.translate(
                offset: const Offset(0, -10),
                child: TopRankedItem(
                    fromOnline: false,
                    rankLabel: "1",
                    name: leaderboard[0]!.country.toUpperCase(),
                    amount: "\$${leaderboard[0]!.totalInvest}",
                    image: AppImagePath.profileImage,
                    rankColor: AppColors.yellow,
                    avatarSize: 55),
              ),
            if (leaderboard.length > 2)
              Transform.translate(
                offset: Offset.zero,
                child: TopRankedItem(
                    fromOnline: false,
                    rankLabel: "3",
                    name: leaderboard[2]!.country.toUpperCase(),
                    amount: "\$${leaderboard[2]!.totalInvest}",
                    image: AppImagePath.profileImage,
                    rankColor: AppColors.orange,
                    avatarSize: 40),
              ),
          ]),
        ),
        Expanded(
          child: Stack(children: [
            ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final data = filteredList[index]!;
                return CountryLeaderboardItem(
                  key: ValueKey('${data.country}${data.totalInvest}$index'),
                  rank: index,
                  name: data.country,
                  amount: "\$${data.totalInvest}",
                  fromNetwork: false,
                  image: AppImagePath.profileImage,
                );
              },
            ),
          ]),
        ),
      ],
    );
  }
}
