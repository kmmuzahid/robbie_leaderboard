import 'dart:math' as AppLogs;

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';
import 'package:the_leaderboard/common/country_iso.dart';
import 'package:the_leaderboard/common/location_picker_controller.dart';
import 'package:the_leaderboard/widgets/image_widget/common_image.dart';

import '../constants/app_colors.dart';

import 'package:flutter_country_state/cty-list.dart';
import 'package:flutter_country_state/select_state.dart';

class CommonCountryPicker extends StatefulWidget {
  const CommonCountryPicker({Key? key, required this.onSelectCountry, this.borderRadious = 8})
      : super(key: key);
  final Function(String country) onSelectCountry;
  final double borderRadious;

  @override
  State<CommonCountryPicker> createState() => _CommonCountryPickerState();
}

class _CommonCountryPickerState extends State<CommonCountryPicker> {
  @override
  void initState() {
    Selected.country = '';
    Selected.state = '';
    Selected.city = '';
    Selected.selectedCityList = [];
    super.initState();
  }

  @override
  void dispose() {
    Selected.country = '';
    Selected.state = '';
    Selected.city = '';
    Selected.selectedCityList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationPickerController>(builder: (controller) {
      return TextField(
        readOnly: true,
        controller: controller.countryInitController,
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
              child: ShowCountryDialog(
                onSelectCountry: () {
                  controller.countryInitController.text = Selected.country;
                  controller.stateInitController.text = '';
                  controller.cityInitController.text = '';
                  widget.onSelectCountry(Selected.country);
                  Selected.state = '';
                  Selected.city = '';
                  Selected.selectedCityList = [];
                },
              ),
            ),
          );
        },
        style: const TextStyle(color: AppColors.white),
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.white),
          hintText: 'Select Country',
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

///this class holds the variable that displays the country and state picked from thge list

class ShowCountryDialog extends StatefulWidget {
  ShowCountryDialog({
    this.substringBackground,
    this.searchHint,
    this.countryListTitle,
    this.subStringStyle,
    this.style,
    this.searchStyle,
    this.selectedCountryBackgroundColor,
    this.notSelectedCountryBackgroundColor,
    required this.onSelectCountry,
    this.countryHeaderStyle,
    this.inputDecoration,
    this.closeIcon,
  });

  final Color? substringBackground;
  final String? searchHint;
  final String? countryListTitle;
  final InputDecoration? inputDecoration;
  final TextStyle? style;
  final TextStyle? subStringStyle;
  final TextStyle? searchStyle;
  final TextStyle? countryHeaderStyle;
  final Color? selectedCountryBackgroundColor;
  final Color? notSelectedCountryBackgroundColor;
  final VoidCallback onSelectCountry;
  final Widget? closeIcon;
  @override
  _ShowCountryDialogState createState() => _ShowCountryDialogState();
}

class _ShowCountryDialogState extends State<ShowCountryDialog> {
  TextEditingController searchController = new TextEditingController();
  String filter = '';
  var itemscolor = <String>[];
  var items = <String>[];
  @override
  initState() {
    super.initState();

    ///merging the list of countries for fast loading
    var newList = [
      Country1.country1,
      Country2.country2,
      Country3.country3,
      Country4.country4,
      Country5.country5,
      Country6.country6,
      Country7.country7,
    ].expand((x) => x).toList();

    items.addAll(newList);
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
              Text(widget.countryListTitle ?? "Select Country",
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
                  hintText: "Search for a country...",
                  hintStyle: const TextStyle(color: AppColors.greyDarker),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: AppColors.greyBlue),
                  ),
                ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return filter == ""
                    ? Container(
                        padding: EdgeInsets.all(10.0),
                        width: double.maxFinite,
                        // color: selectedIndex.contains(index)
                        //     ? widget.selectedCountryBackgroundColor??Colors.grey
                        //     : widget.notSelectedCountryBackgroundColor?? Colors.red,
                        child: _item(
                            title: items[index],
                            onTap: () {
                              _selectedICountry(items[index], index);
                            }))
                    : '${items[index]}'.toLowerCase().contains(filter.toLowerCase())
                        ? Container(
                            padding: EdgeInsets.all(10.0),
                            width: double.maxFinite,
                            child: _item(
                                title: items[index],
                                onTap: () async {
                                  _selectedICountry(items[index], index);
                                }),
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
        leading: SizedBox(
          width: 30,
          height: 20,
          child: CountryFlag.fromCountryCode(Countries.all[title]!),
        ),
        title: Text(title, style: const TextStyle(fontSize: 18, color: AppColors.white)),
        onTap: () async {
          onTap();
        });
  }

  _selectedICountry(String data, int index) async {
    setState(() {
      Selected.country = data;
      selectedIndex.clear();
      selectedIndex.add(index);
      stateFunction().stateList();
    });
    widget.onSelectCountry();
    setState(() {});
    Get.back();
  }
}
