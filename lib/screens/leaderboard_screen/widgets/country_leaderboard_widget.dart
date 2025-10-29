import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/constants/app_image_path.dart';
import 'package:the_leaderboard/models/country_leaderboard_model.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/country_leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item_country.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class CountryLeaderboardWidget extends StatelessWidget {
  const CountryLeaderboardWidget(
      {super.key, required this.leaderboard, required this.controller});
  final List<CountryLeaderboardModel?> leaderboard;
  final LeaderboardController controller;
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
                child: TopRankItemCountry(
                    fromOnline:
                        false, //leaderboard[1]!.profileImg != "Unknown",
                    rankLabel: "2",
                    name: leaderboard[1]!.country.toUpperCase(),
                    amount:
                        "\$${AppCommonFunction.formatNumber(leaderboard[1]!.totalInvest)}",
                    image: CountryFlag.fromCountryCode(
                      controller.isoCodes[1],
                      theme: const ImageTheme(
                          shape: Circle(), width: 90, height: 90),
                    ),
                    rankColor: AppColors.greyDark,
                    avatarSize: 40),
              ),
            if (leaderboard.isNotEmpty)
              Transform.translate(
                offset: const Offset(0, -10),
                child: TopRankItemCountry(
                    fromOnline: false,
                    rankLabel: "1",
                    name: leaderboard[0]!.country.toUpperCase(),
                    amount:
                        "\$${AppCommonFunction.formatNumber(leaderboard[0]!.totalInvest)}",
                    image: CountryFlag.fromCountryCode(
                      controller.isoCodes[0],
                      theme: const ImageTheme(
                          shape: Circle(), width: 100, height: 100),
                    ),
                    rankColor: AppColors.yellow,
                    avatarSize: 55),
              ),
            if (leaderboard.length > 2)
              Transform.translate(
                offset: Offset.zero,
                child: TopRankItemCountry(
                    fromOnline: false,
                    rankLabel: "3",
                    name: leaderboard[2]!.country.toUpperCase(),
                    amount:
                        "\$${AppCommonFunction.formatNumber(leaderboard[2]!.totalInvest)}",
                    image: CountryFlag.fromCountryCode(
                      controller.isoCodes[2],
                      theme: const ImageTheme(
                          shape: Circle(), width: 90, height: 90),
                    ),
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
                  rank: index + 4,
                  name: data.country,
                  amount:
                      "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
                  fromNetwork: false,
                  image: CountryFlag.fromCountryCode(
                    controller.isoCodes[index + 3],
                    theme: const ImageTheme(
                        shape: Circle(), width: 50, height: 50),
                  ),
                );
              },
            ),
          ]),
        ),
      ],
    );
  }
}
