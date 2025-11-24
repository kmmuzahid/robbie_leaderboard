import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:the_leaderboard/common/country_iso.dart';
import 'package:the_leaderboard/constants/app_colors.dart';
import 'package:the_leaderboard/models/country_leaderboard_model.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/country_leaderboard_item.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/widgets/top_rank_item_country.dart';
import 'package:the_leaderboard/services/storage/storage_services.dart';
import 'package:the_leaderboard/utils/app_common_function.dart';
import 'package:the_leaderboard/utils/app_logs.dart';
import 'package:the_leaderboard/widgets/space_widget/space_widget.dart';
import 'package:the_leaderboard/widgets/text_widget/text_widgets.dart';

class CountryLeaderboardWidget extends StatelessWidget {
  const CountryLeaderboardWidget({super.key, required this.leaderboard, required this.onRefresh});
  final List<CountryLeaderboardModel?> leaderboard;
  final Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    final filteredList = leaderboard; //leaderboard.skip(3).where((e) => e != null).toList();
    String userId = StorageService.userId;
    appLog("mydata");
    appLog(userId);

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
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh.call();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              if (leaderboard.length > 1 && leaderboard[1] != null)
                Transform.translate(
                  offset: Offset.zero,
                  child: TopRankItemCountry(
                      fromOnline: false,
                      rankLabel: '2',
                      name: leaderboard[1]?.country.toUpperCase() ?? 'N/A',
                      amount:
                          "\$${AppCommonFunction.formatNumber(leaderboard[1]?.totalInvest ?? 0)}",
                      image: CountryFlag.fromCountryCode(
                        leaderboard[1]?.country != null
                            ? (Countries.getIsoCode(leaderboard[1]!.country))
                            : "",
                        theme: const ImageTheme(shape: Circle(), width: 90, height: 90),
                      ),
                      rankColor: AppColors.greyDark,
                      avatarSize: 40),
                ),
              if (leaderboard.isNotEmpty && leaderboard[0] != null)
                Transform.translate(
                  offset: const Offset(0, -10),
                  child: TopRankItemCountry(
                      fromOnline: false,
                      rankLabel: '1',
                      name: leaderboard[0]?.country.toUpperCase() ?? 'N/A',
                      amount:
                          "\$${AppCommonFunction.formatNumber(leaderboard[0]?.totalInvest ?? 0)}",
                      image: CountryFlag.fromCountryCode(
                        leaderboard[0]?.country != null
                            ? (Countries.getIsoCode(leaderboard[0]!.country))
                            : "",
                        theme: const ImageTheme(shape: Circle(), width: 100, height: 100),
                      ),
                      rankColor: AppColors.yellow,
                      avatarSize: 55),
                ),
              if (leaderboard.length > 2 && leaderboard[2] != null)
                Transform.translate(
                  offset: Offset.zero,
                  child: TopRankItemCountry(
                      fromOnline: false,
                      rankLabel: '3',
                      name: leaderboard[2]?.country.toUpperCase() ?? 'N/A',
                      amount:
                          "\$${AppCommonFunction.formatNumber(leaderboard[2]?.totalInvest ?? 0)}",
                      image: CountryFlag.fromCountryCode(
                        leaderboard[2]?.country != null
                            ? (Countries.getIsoCode(leaderboard[2]!.country))
                            : "",
                        theme: const ImageTheme(shape: Circle(), width: 90, height: 90),
                      ),
                      rankColor: AppColors.orange,
                      avatarSize: 40),
                ),
            ]),
          ),
          if (leaderboard.length > 3)
          Expanded(
              child: _list(filteredList.sublist(3)),
            ),
        ],
      ),
    );
  }

  ListView _list(List<CountryLeaderboardModel?> filteredList) {
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final data = filteredList[index]!;
        return CountryLeaderboardItem(
          key: ValueKey('${data.country}${data.totalInvest}$index'),
          rank: index + 4,
          name: data.country,
          amount: "\$${AppCommonFunction.formatNumber(data.totalInvest)}",
          fromNetwork: false,
          image: CountryFlag.fromCountryCode(
            (Countries.getIsoCode(data.country)),
            theme: const ImageTheme(shape: Circle(), width: 50, height: 50),
          ),
        );
      },
    );
  }
}
