import 'dart:math';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/constants.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/ui/custom_dropdown.dart';
import 'package:careflix/layers/data/params/search_params.dart';
import 'package:careflix/layers/view/lists_screen/widget/heading_widget.dart';
import 'package:careflix/layers/view/search_screen/filters/show_filter_cubit.dart';
import 'package:careflix/layers/view/search_screen/filters/show_filter_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';
import '../../../../injection_container.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({super.key});

  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  final _showFilterCubit = sl<ShowFilterCubit>();

  List<int> getYears() {
    int currentYear = DateTime.now().year;
    return List.generate(currentYear - (currentYear - 20),
        (index) => index + 1 + (currentYear - 20)).reversed.toList();
  }

  late final InputBorder inputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Styles.backgroundColor,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(30),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).filters),
      ),
      body: BlocBuilder<ShowFilterCubit, ShowFilterState>(
        bloc: _showFilterCubit,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingWidget(
                  title: S.of(context).date,
                  padding: 20.w,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  child: CustomDropDown<int>(
                    hintText: S.of(context).chooseDate,
                    verticalDropdownPadding: 20.h,
                    dropDownItems: getYears().map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          value.toString(),
                        ),
                      );
                    }).toList(),
                    selectedValue: state.dateYear,
                    onChanged: (value) {
                      _showFilterCubit.onChangeFilterData(dateYear: value);
                    },
                  ),
                ),
                CommonSizes.vBiggerSpace,
                HeadingWidget(
                  title: S.of(context).type,
                  padding: 20.w,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  child: CustomDropDown<String>(
                    hintText: S.of(context).chooseType,
                    verticalDropdownPadding: 20.h,
                    dropDownItems: Constants.showTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.toString(),
                        ),
                      );
                    }).toList(),
                    selectedValue: state.showLan != null
                        ? showLanToString(state.showLan!)
                        : null,
                    onChanged: (value) {
                      _showFilterCubit.onChangeFilterData(
                          showType: stringToShowLanFilter(value));
                    },
                  ),
                ),
                CommonSizes.vBiggerSpace,
                HeadingWidget(
                  title: S.of(context).category,
                  padding: 20.w,
                  textStyle:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
                  child: Stack(
                    children: [
                      CustomDropDown<String>(
                        hintText: "",
                        verticalDropdownPadding: 20.h,
                        dropDownItems:
                            Constants.showCategories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color:
                                      state.selectedCategories.contains(value)
                                          ? Styles.colorPrimary
                                          : null),
                            ),
                          );
                        }).toList(),
                        selectedItemBuilder: (_) {
                          return Constants.showCategories
                              .map<Widget>((String item) {
                            return Text(
                              item,
                              style: TextStyle(color: Colors.transparent),
                            );
                          }).toList();
                        },
                        onChanged: (value) {
                          _showFilterCubit.addCategory(value);
                        },
                      ),
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        start: 13,
                        top: 13,
                        child: IgnorePointer(
                          ignoring: true,
                          child: DropdownButtonHideUnderline(
                            child: Text(
                              S.of(context).chooseCategory, // Hint text
                              style: TextStyle(
                                  fontSize: Styles.fontSize5,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color!
                                      .withOpacity(0.7)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CommonSizes.vSmallerSpace,
                Wrap(
                    spacing: 10,
                    runSpacing: 0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      ...List.generate(
                          state.selectedCategories.length,
                          (index) => Chip(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              backgroundColor: Styles.categoryColors[Random()
                                  .nextInt(Styles.categoryColors.length)],
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              label: Text(
                                state.selectedCategories[index],
                                style: TextStyle(color: Colors.white),
                              ),
                              deleteIconColor: Colors.white,
                              onDeleted: () {
                                _showFilterCubit.removeCategory(
                                    state.selectedCategories[index]);
                              },
                              deleteIcon: Icon(Icons.close)))
                    ]),
                CommonSizes.vBiggestSpace,
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(SearchParams(
                            year: state.dateYear != null
                                ? state.dateYear.toString()
                                : "",
                            categories: state.selectedCategories,
                            showLan: state.showLan));
                      },
                      child: Text(
                        S.of(context).save,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Styles.colorPrimary),
                    )),
                    CommonSizes.hBigSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showFilterCubit.resetFilterData();
                        },
                        child: Text(
                          S.of(context).reset,
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.colorTertiary),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
