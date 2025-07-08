import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/search_screen/controller/search_screen_controller.dart';
import 'package:the_leaderboard/screens/search_screen/widgets/age_icon_button.dart';
import 'package:the_leaderboard/screens/search_screen/widgets/age_text_widget.dart';
import 'package:the_leaderboard/screens/search_screen/widgets/dropdown_button_widget.dart';
import 'package:the_leaderboard/screens/search_screen/widgets/title_text_widget.dart';
import 'package:the_leaderboard/widgets/button_widget/button_widget.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/space_widget/space_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller using Get.put()
    final SearchScreenController controller = Get.put(SearchScreenController());

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.blueDark,
        appBar:
            const AppbarWidget(title: AppStrings.searching, centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search
                const TitleTextWidget(text: AppStrings.search),
                const SpaceWidget(spaceHeight: 8),
                TextField(
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: 'Type here...',
                    hintStyle: const TextStyle(
                      color: AppColors.white,
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

                // Country
                const TitleTextWidget(text: AppStrings.country),
                const SpaceWidget(spaceHeight: 8),
                Obx(() => DropdownButtonWidget(
                      value: controller.selectedCountry.value,
                      items: controller.countries,
                      onChanged: (value) {
                        controller.updateCountry(value!);
                      },
                    )),

                const SpaceWidget(spaceHeight: 14),

                // City
                const TitleTextWidget(text: AppStrings.city),
                const SpaceWidget(spaceHeight: 8),
                Obx(() => DropdownButtonWidget(
                      value: controller.selectedCity.value,
                      items: controller.cities,
                      onChanged: (value) {
                        controller.updateCity(value!);
                      },
                    )),

                const SpaceWidget(spaceHeight: 14),

                // Age
                const TitleTextWidget(text: AppStrings.age),
                const SpaceWidget(spaceHeight: 8),
                Row(
                  children: [
                    Obx(() =>
                        AgeTextWidget(text: '${controller.minAge.value} Y')),
                    const SpaceWidget(spaceWidth: 8),
                    const TextWidget(
                      text: AppStrings.to,
                      fontColor: AppColors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                    const SpaceWidget(spaceWidth: 8),
                    Obx(() =>
                        AgeTextWidget(text: '${controller.maxAge.value} Y')),
                    const SpaceWidget(spaceWidth: 12),
                    AgeIconButton(
                      icon: const Icon(Icons.add),
                      onPressed: controller.incrementMaxAge,
                    ),
                    const SpaceWidget(spaceWidth: 12),
                    AgeIconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: controller.decrementMinAge,
                    ),
                  ],
                ),

                const SpaceWidget(spaceHeight: 14),

                // Gender
                const TitleTextWidget(text: AppStrings.gender),
                const SpaceWidget(spaceHeight: 8),
                Obx(() => DropdownButtonWidget(
                      value: controller.selectedGender.value,
                      items: controller.genders,
                      onChanged: (value) {
                        controller.updateGender(value!);
                      },
                    )),

                const SpaceWidget(spaceHeight: 48),

                // Search Button
                ButtonWidget(
                  onPressed: controller.search,
                  label: AppStrings.searchNow,
                  buttonWidth: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
