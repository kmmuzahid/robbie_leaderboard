import 'package:flutter/material.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LocationPickerController extends GetxController {
  late TextEditingController stateInitController;
  late TextEditingController countryInitController;
  late TextEditingController cityInitController;

  @override
  void onInit() {
    stateInitController = TextEditingController();
    countryInitController = TextEditingController();
    cityInitController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    stateInitController.dispose();
    countryInitController.dispose();
    cityInitController.dispose();
    super.onClose();
  }
}
