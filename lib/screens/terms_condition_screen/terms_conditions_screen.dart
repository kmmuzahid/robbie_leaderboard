import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:the_leaderboard/screens/terms_condition_screen/controller/term_and_condition_controller.dart';
import '../../constants/app_colors.dart';
import '../../widgets/appbar_widget/appbar_widget.dart';
import '../../widgets/text_widget/text_widgets.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final _controller = Get.put(TermAndConditionController());

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
            appBar: const AppbarWidget(
                title: "Terms & Conditions", centerTitle: true),
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
                    child: Text(
                      "There is no term and condition",
                      style: TextStyle(color: AppColors.white),
                    ),
                  );
                }
                return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: HtmlWidget(
                      data,
                      textStyle: const TextStyle(
                        color: AppColors.white,
                      ),
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
