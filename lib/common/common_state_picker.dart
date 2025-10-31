import 'package:flutter/material.dart';
import 'package:flutter_country_state/flutter_country_state.dart';
import 'package:flutter_country_state/state-list.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';
import 'common_country_picker.dart';
import 'location_picker_controller.dart';

class CommonStatePicker extends StatefulWidget {
  const CommonStatePicker({Key? key, required this.onSelectState, this.borderRadious = 8})
      : super(key: key);
  final Function(String state) onSelectState;
  final double borderRadious;

  @override
  State<CommonStatePicker> createState() => _CommonStatePickerState();
}

class _CommonStatePickerState extends State<CommonStatePicker> {
  @override
  void initState() {
    Selected.state = '';
    super.initState();
  }

  @override
  void dispose() {
    Selected.state = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationPickerController>(builder: (controller) {
      return TextField(
        readOnly: true,
        controller: controller.stateInitController,
        onTap: () {
          if (controller.countryInitController.text.isEmpty) {
            Get.snackbar(
                "Select Country First", "To select a state, please select a country first.",
                colorText: AppColors.white);
            return;
          }
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
              child: ShowStateDialog(
                onSelectedState: () {
                  controller.stateInitController.text = Selected.state;
                  controller.cityInitController.text = '';
                  widget.onSelectState(Selected.state);
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
          hintText: 'Select State',
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

class ShowStateDialog extends StatefulWidget {
  ShowStateDialog({
    this.substringBackground,
    this.subStringStyle,
    this.style,
    this.selectedStateBackgroundColor,
    this.notSelectedStateBackgroundColor,
    required this.onSelectedState,
    this.stateHeaderStyle,
    this.closeIcon,
  });

  final Color? substringBackground;
  final TextStyle? style;
  final TextStyle? subStringStyle;
  final TextStyle? stateHeaderStyle;
  final Color? selectedStateBackgroundColor;
  final Color? notSelectedStateBackgroundColor;
  final VoidCallback onSelectedState;
  final Widget? closeIcon;

  @override
  _ShowStateDialogState createState() => _ShowStateDialogState();
}

class _ShowStateDialogState extends State<ShowStateDialog> {
  List<int> selectedState = [];
  late TextEditingController searchController;
  String filter = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchController.addListener(() {
      setState(() {
        filter = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<String> get filteredStates {
    if (filter.isEmpty) return StateDialogs.stateItems;
    return StateDialogs.stateItems.where((state) => state.toLowerCase().contains(filter)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topRight,
            child: Row(
              children: [
                const Spacer(),
                Text("Select State",
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
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
            child: TextField(
              style: const TextStyle(fontSize: 18, color: AppColors.white),
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search for a state...",
                hintStyle: const TextStyle(color: AppColors.greyDarker),
                contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Expanded(
            child: filteredStates.isEmpty
                ? const Center(
                    child: Text(
                      'No states found',
                      style: TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredStates.length,
                    itemBuilder: (context, index) {
                      final state = filteredStates[index];
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        width: double.maxFinite,
                        child: _item(
                          title: state,
                          onTap: () {
                            _userSelectedCountryState(context, state, index);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
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

  void _userSelectedCountryState(BuildContext context, String data, int index) {
    setState(() {
      Selected.state = data;
      selectedState.clear();
      selectedState.add(StateDialogs.stateItems.indexOf(data));
    });
    Navigator.pop(context);
    widget.onSelectedState();
  }
}
