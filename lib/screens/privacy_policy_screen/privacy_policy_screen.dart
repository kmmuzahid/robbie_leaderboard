import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/privacy_policy_screen/controller/privacy_policy_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<PrivacyPolicyScreen> {
  final _controller = Get.put(PrivacyPolicyController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
            backgroundColor: AppColors.blueDark,
            appBar:
                const AppbarWidget(title: "Privacy Policy", centerTitle: true),
            body: Obx(
              () {
                if (_controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = _controller.termAndCondition.value;
                if (data.isEmpty) {
                  return const Center(
                    child: TextWidget(
                      text: "There is no privacy policy",
                      fontColor: AppColors.white,
                    ),
                  );
                }
                return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: HtmlWidget(
                      data,
                      textStyle: const TextStyle(color: AppColors.white),
                      onTapUrl: (url) => launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication),
                    ));
              },
            )));

    // Obx(() =>
    //     const SingleChildScrollView(
    //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           TextWidget(
    //             text:
    //                 "${}",
    //     fontColor: AppColors.white,
    //     fontWeight: FontWeight.w400,
    //     fontSize: 15,
    //     textAlignment: TextAlign.start,

    // SpaceWidget(spaceHeight: 16),
    // TextWidget(
    //   text:
    //       "Celebrate Creativity: Inspire smiles with designs that tell stories.",
    //   fontColor: AppColors.white,
    //   fontWeight: FontWeight.w400,
    //   fontSize: 15,
    //   textAlignment: TextAlign.start,
    // ),
    // SpaceWidget(spaceHeight: 16),
    // TextWidget(
    //   text:
    //       "Foster Memories: Offer products that become cherished keepsakes.",
    //   fontColor: AppColors.white,
    //   fontWeight: FontWeight.w400,
    //   fontSize: 15,
    //   textAlignment: TextAlign.start,
    // ),
    // SpaceWidget(spaceHeight: 16),
    // TextWidget(
    //   text:
    //       "Enhance Experiences: Add a touch of wonder to every shopping journey.",
    //   fontColor: AppColors.white,
    //   fontWeight: FontWeight.w400,
    //   fontSize: 15,
    //   textAlignment: TextAlign.start,
    // ),
    // SpaceWidget(spaceHeight: 16),
    // TextWidget(
    //   text:
    //       "At Duckie Wonderland, we are more than a brand – we are The Happy Family, spreading joy, creativity, and wonder to everyone who walks through our doors",
    //   fontColor: AppColors.white,
    //   fontWeight: FontWeight.w400,
    //   fontSize: 15,
    //   textAlignment: TextAlign.start,
    // ),
  }
}
