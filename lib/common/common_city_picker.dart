import 'dart:math' as AppLogs;

import 'package:flutter/material.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../constants/app_colors.dart';
import 'all_alliance.dart';
import 'common_country_picker.dart';
import 'location_picker_controller.dart';

class CommonCityPicker extends StatefulWidget {
  const CommonCityPicker({Key? key, required this.onSelectCity, this.borderRadious = 8})
      : super(key: key);
  final Function(String city) onSelectCity;
  final double borderRadious;

  @override
  State<CommonCityPicker> createState() => _CommonCityPickerState();
}

class _CommonCityPickerState extends State<CommonCityPicker> {
  @override
  void initState() {
    Selected.city = '';
    super.initState();
  }

  @override
  void dispose() {
    Selected.city = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationPickerController>(builder: (controller) {
      return TextField(
        readOnly: true,
        controller: controller.cityInitController,
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            isDismissible: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            backgroundColor: AppColors.blue,
            builder: (context) => SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ShowCityDialog(
                onSelectedCity: () {
                  controller.cityInitController.text = Selected.city;
                  widget.onSelectCity(Selected.city);
                },
              ),
            ),
          );
        },
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.white),
          hintText: 'Select City',
          hintStyle: const TextStyle(
            color: AppColors.greyDarker,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: AppColors.blue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadious),
            borderSide: BorderSide.none,
          ),
        ),
      );
    });
  }
}

class ShowCityDialog extends StatefulWidget {
  ShowCityDialog({
    this.substringBackground,
    this.searchHint,
    this.cityListTitle,
    this.subStringStyle,
    this.style,
    this.searchStyle,
    this.selectedCityBackgroundColor,
    this.notSelectedCityBackgroundColor,
    required this.onSelectedCity,
    this.countryHeaderStyle,
    this.inputDecoration,
    this.closeIcon,
  });

  final Color? substringBackground;
  final String? searchHint;
  final String? cityListTitle;
  final InputDecoration? inputDecoration;
  final TextStyle? style;
  final TextStyle? subStringStyle;
  final TextStyle? searchStyle;
  final TextStyle? countryHeaderStyle;
  final Color? selectedCityBackgroundColor;
  final Color? notSelectedCityBackgroundColor;
  final VoidCallback onSelectedCity;
  final Widget? closeIcon;
  @override
  _ShowCityDialogState createState() => _ShowCityDialogState();
}

class _ShowCityDialogState extends State<ShowCityDialog> {
  TextEditingController searchController = new TextEditingController();
  String filter = '';
  var itemscolor = <String>[];
  getTheCities() {
    List<Map<String, dynamic>>? selectedCountryData;

// Find the selected country
    for (var countryData in allStatesWithCities) {
      if (countryData is Map<String, dynamic> && countryData.containsKey(Selected.country)) {
        selectedCountryData = countryData[Selected.country];
        break;
      }
    }

// Check if the selected country was found
    if (selectedCountryData != null) {
      // Find the selected state and get its cities
      for (var stateData in selectedCountryData) {
        for (var stateEntry in stateData.entries) {
          String stateName = stateEntry.key;
          if (stateName == Selected.state) {
            // Get the list of cities for the selected state
            Selected.selectedCityList = stateEntry.value;

            break;
          }
        }
      }
    } else {
      print('Selected country not found');
    }
  }

  @override
  initState() {
    super.initState();
    getTheCities();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text;
      });
    });
  }

  List<int> selectedIndex = [];
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.topRight,
          child: Row(
            children: [
              const Spacer(),
              Text("Select City",
                  style: TextStyle(
                      color: AppColors.gradientColorEnd,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
          child: TextField(
            style: widget.searchStyle ?? TextStyle(fontSize: 18, color: AppColors.white),
            controller: searchController,
            decoration: widget.inputDecoration ??
                InputDecoration(
                  hintText: "Search for a city...",
                  hintStyle: const TextStyle(color: AppColors.greyDarker),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: Selected.selectedCityList.length,
              itemBuilder: (context, index) {
                var pickedCity = Selected.selectedCityList[index];
                return filter == ""
                    ? Container(
                        padding: const EdgeInsets.all(10.0),
                        width: double.maxFinite,
                        // color: selectedIndex.contains(index)
                        //     ? widget.selectedCityBackgroundColor??Colors.blue
                        //     : widget.notSelectedCityBackgroundColor??Colors.transparent,
                        child: _item(
                            title: pickedCity,
                            onTap: () {
                              _selectedICountry(pickedCity, index);
                            }))
                    : '$pickedCity'.toLowerCase().contains(filter.toLowerCase())
                        ? Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              width: double.maxFinite,
                              //                       color: selectedIndex.contains(index)
                              //                     ? widget.selectedCityBackgroundColor??Colors.blue
                              // : widget.notSelectedCityBackgroundColor??Colors.black,
                              child: _item(
                                  title: pickedCity,
                                  onTap: () {
                                    _selectedICountry(pickedCity, index);
                                  }),
                            ),
                          )
                        : Container(
                            width: double.maxFinite,
                          );
              }),
        ),
      ],
    );
  }

  Widget _item({required String title, required Function onTap}) {
    return ListTile(
        leading: const SizedBox(
          width: 30,
          height: 20,
          child: Icon(Icons.location_city_outlined, color: AppColors.goldLight),
        ),
        title: Text(title, style: const TextStyle(fontSize: 18, color: AppColors.white)),
        onTap: () async {
          onTap();
        });
  }

  _selectedICountry(String data, int index) async {
    setState(() {
      Selected.city = data;
      selectedIndex.clear();
      selectedIndex.add(index);
    });
    widget.onSelectedCity();
    setState(() {});
    Navigator.pop(context);
  }
}
