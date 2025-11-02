import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/common/common_city_picker.dart';
import 'package:the_leaderboard/common/common_country_picker.dart';
import 'package:the_leaderboard/common/common_state_picker.dart';
import 'package:the_leaderboard/screens/leaderboard_filtered_screen/leaderboard_filtered_screen.dart';
import 'package:the_leaderboard/screens/leaderboard_screen/controller/leaderboard_controller.dart';
import 'package:the_leaderboard/screens/search_screen/controller/search_screen_controller.dart';
import 'package:the_leaderboard/screens/search_screen/widgets/common_drop_down.dart';
import 'package:the_leaderboard/screens/search_screen/widgets/title_text_widget.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/space_widget/space_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: GetBuilder<SearchScreenController>(builder: (controller) {
        return Scaffold(
        backgroundColor: AppColors.blueDark,
            appBar: AppbarWidget(
                title: AppStrings.searching,
                centerTitle: true,
                action: IconButton(
                    onPressed: () {
                      controller.clearFilter();
                    },
                    icon: Icon(color: AppColors.white, Icons.cleaning_services))),
            body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Obx(() {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Field with Obx
                      const TitleTextWidget(text: 'Leaderboard Type'),
                      const SpaceWidget(spaceHeight: 8),

                      CommonDropDown(
                          key: ValueKey(controller.leaderboardType.value),
                          backgroundColor: AppColors.blue,
                          textStyle: const TextStyle(color: AppColors.white),
                          borderColor: AppColors.blue,
                          borderRadius: 16,
                          hint: 'Select Type',
                          selectedValue: controller.leaderboardType.value ==
                                  LeaderboardType.leaderboard
                              ? 'Leaderboard'
                              : controller.leaderboardType.value == LeaderboardType.eventLeaderboard
                                  ? 'Event Leaderboard'
                                  : 'Creator Leaderboard',
                          items: const [
                            'Leaderboard',
                            'Event Leaderboard',
                            'Creator Leaderboard',
                          ],
                          onChanged: (value) {
                            if (value == 'Leaderboard') {
                              controller.updateSearchType(LeaderboardType.leaderboard);
                            } else if (value == 'Event Leaderboard') {
                              controller.updateSearchType(LeaderboardType.eventLeaderboard);
                            } else if (value == 'Creator Leaderboard') {
                              controller.updateSearchType(LeaderboardType.creatorLeaderboard);
                            }
                          },
                          nameBuilder: (value) => value),
                      const SpaceWidget(spaceHeight: 8),
                      const TitleTextWidget(text: AppStrings.search),
                      const SpaceWidget(spaceHeight: 8),
                      TextField(
                        controller: controller.nameController,
                        style: const TextStyle(color: AppColors.white),
                        decoration: InputDecoration(
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
                      const SpaceWidget(spaceHeight: 14),
                      const SpaceWidget(spaceHeight: 14),

                      // Country
                      if (controller.leaderboardType.value != LeaderboardType.eventLeaderboard) ...[
                        const TitleTextWidget(text: AppStrings.country),
                        const SpaceWidget(spaceHeight: 8),
                        CommonCountryPicker(onSelectCountry: (country) {}),

                        // CommonDropDown(
                        //     backgroundColor: AppColors.blue,
                        //     textStyle: const TextStyle(color: AppColors.white),
                        //     borderColor: AppColors.blue,
                        //     borderRadius: 16,
                        //     hint: 'Select Country',
                        //     items: controller.countryList,
                        //     enableInitalSelection: false,
                        //     onChanged: (value) => controller.updateCountry(value!.isoCode),
                        //     nameBuilder: (value) => value.name),
                        const SpaceWidget(spaceHeight: 8),

                        const TitleTextWidget(text: 'State'),
                        const SpaceWidget(spaceHeight: 8),
                        CommonStatePicker(onSelectState: (state) {
                          // controller.selectedState.value = state;
                        }),
                        const SpaceWidget(spaceHeight: 8),
                        const TitleTextWidget(text: AppStrings.city),
                        const SpaceWidget(spaceHeight: 8),
                        CommonCityPicker(onSelectCity: (city) {}),

                        const SpaceWidget(spaceHeight: 14),

                        // Gender
                        const TitleTextWidget(text: AppStrings.gender),
                        const SpaceWidget(spaceHeight: 8),
                        CommonDropDown<String>(
                            key: ValueKey(controller.selectedGenderKey),
                            backgroundColor: AppColors.blue,
                            selectedValue: controller.selectedGender.value,
                            textStyle: const TextStyle(color: AppColors.white),
                            borderColor: AppColors.blue,
                            borderRadius: 16,
                            hint: 'Select Gender',
                            items: controller.genders,
                            enableInitalSelection: false,
                            onChanged: controller.updateGender,
                            nameBuilder: (value) => value),
                      ],
                
                      const SpaceWidget(spaceHeight: 48),

                      // Search Button
                      ButtonWidget(
                        onPressed: () {
                          Get.to(const LeaderboardFilteredScreen());
                        },
                        label: AppStrings.searchNow,
                        buttonWidth: double.infinity,
                      ),
                    ],
                  ),
                   
                );
              }),
            ));
      }
        ),
    );
  }
}
