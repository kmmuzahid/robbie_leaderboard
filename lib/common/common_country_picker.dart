import 'dart:math' as AppLogs;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path/path.dart';

import '../constants/app_colors.dart';

import 'package:flutter_country_state/cty-list.dart';
import 'package:flutter_country_state/select_state.dart';

class Selected {
  static String country = '';
  static String state = '';
  static String city = '';
  static List selectedCityList = [];
}

class CommonCountryPicker extends StatefulWidget {
  const CommonCountryPicker({Key? key, required this.onSelectCountry}) : super(key: key);
  final Function(String country) onSelectCountry;

  @override
  State<CommonCountryPicker> createState() => _CommonCountryPickerState();
}

class _CommonCountryPickerState extends State<CommonCountryPicker> {
  late TextEditingController searchController;
  @override
  void initState() {
    Selected.country = '';
    Selected.state = '';
    Selected.city = '';
    Selected.selectedCityList = [];
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    Selected.country = '';
    Selected.state = '';
    Selected.city = '';
    Selected.selectedCityList = [];
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      controller: searchController,
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
                searchController.text = Selected.country;
                widget.onSelectCountry(Selected.country);
              },
            ),
          ),
        );
      },
      style: const TextStyle(color: AppColors.white),
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.arrow_drop_down, color: AppColors.white),
        hintText: 'Select Country',
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
    );
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
        widget.closeIcon ??
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
                ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var users = items[index];
                    return filter == ""
                        ? Container(
                            padding: EdgeInsets.all(10.0),
                            width: double.maxFinite,
                            // color: selectedIndex.contains(index)
                            //     ? widget.selectedCountryBackgroundColor??Colors.grey
                            //     : widget.notSelectedCountryBackgroundColor?? Colors.red,
                            child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: widget.substringBackground ?? Colors.blue,
                                  child: Text(users.substring(0, 1).toUpperCase(),
                                      style: widget.subStringStyle ?? TextStyle(fontSize: 20)),
                                ),
                                title: Text(items[index],
                                    style: TextStyle(fontSize: 18, color: AppColors.white)),
                                onTap: () {
                                  _selectedICountry(items[index], index);
                                }))
                        : '${items[index]}'.toLowerCase().contains(filter.toLowerCase())
                            ? Container(
                                padding: EdgeInsets.all(10.0),
                                width: double.maxFinite,
                                // color: selectedIndex.contains(index)
                                //     ? widget.selectedCountryBackgroundColor??Colors.blue
                                //     : widget.notSelectedCountryBackgroundColor?? Colors.black,
                                child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: widget.substringBackground ?? Colors.blue,
                                      child: Text(users.substring(0, 1).toUpperCase(),
                                          style: widget.subStringStyle ?? TextStyle(fontSize: 20)),
                                    ),
                                    title: Text(items[index],
                                        style: TextStyle(fontSize: 18, color: AppColors.white)),
                                    onTap: () async {
                                      _selectedICountry(items[index], index);
                                    }),
                              )
                            : Container(
                                width: double.maxFinite,
                              );
                  }),
            ],
          ),
        ),
      ],
    );
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
