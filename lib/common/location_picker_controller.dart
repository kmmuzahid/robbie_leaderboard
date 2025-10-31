import 'package:flutter/material.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LocationPickerController extends GetxController {
  late TextEditingController stateInitController;
  late TextEditingController countryInitController;
  late TextEditingController cityInitController;

  init(String country, String city) {
    countryInitController.text = country;
    cityInitController.text = city;
    Selected.country = country;
    Selected.city = city;
  }

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
