import 'dart:async';

import 'package:careflix/core/app/state/app_state.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/enum.dart';
import 'package:careflix/core/extended/extention.dart';
import 'package:careflix/core/shared_preferences/shared_preferences_instance.dart';
import 'package:careflix/core/shared_preferences/shared_preferences_key.dart';
import 'package:careflix/layers/data/data_provider/rule_provider.dart';
import 'package:careflix/layers/data/model/rule.dart';
import 'package:careflix/layers/view/coming_soon_show/coming_soon_show.dart';
import 'package:careflix/layers/view/lists_screen/lists_screen.dart';
import 'package:careflix/layers/view/search_screen/search_screen.dart';
import 'package:careflix/layers/view/settings/settings_screen.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../injection_container.dart';
import '../data/model/duration_rule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Timer timer;
  final screens = [
    ListsScreen(),
    SearchScreen(),
    ComingSoonShow(),
    SettingsScreen(),
  ];

  bool checkIfBlocked(Rule rule) {
    if (checkIfDateIsBlocked(rule.blockedDates ?? [])) {
      return true;
    }

    if (checkIfTimeBlocked(rule.openTime ?? 0, rule.closeTime ?? 24)) {
      return true;
    }

    if (checkIfPeriodIsBlocked(rule.durationRules ?? [])) {
      return true;
    }

    if (rule.isOn != null && !rule.isOn!) {
      print("off");
      return true;
    }

    return false;
  }

  bool checkIfDateIsBlocked(List<DateTime> blockedDates) {
    for (DateTime blockedDate in blockedDates) {
      if (blockedDate.isSameDate(DateTime.now())) {
        return true;
      }
    }
    return false;
  }

  bool checkIfTimeBlocked(int openTime, closeTime) {
    DateTime now = new DateTime.now();
    if (now.hour >= openTime && now.hour < closeTime) {
      return false;
    }
    return true;
  }

  bool checkIfPeriodIsBlocked(List<DurationRule> durationRules) {
    DateTime now = new DateTime.now();
    String weekdayName = DateFormat('EEEE', "en").format(now);
    DurationRule? rule;
    for (DurationRule durationRule in durationRules) {
      if (durationRule.weekDay.toShortString().toUpperCase() ==
          weekdayName.toUpperCase()) {
        rule = durationRule;
      }
    }
    print(rule);
    if (rule != null) {
      if (!rule.active) {
        return false;
      }
      int minutes = (rule!.hour * 60).toInt() + rule!.minute;
      if (SharedPreferencesInstance.pref
                  .getInt(SharedPreferencesKeys.UsagePeriod) !=
              null &&
          SharedPreferencesInstance.pref
                  .getInt(SharedPreferencesKeys.UsagePeriod)! >=
              minutes) {
        return true;
      }
    }
    return false;
  }

  _handleIndexChanged(int index) {
    setState(() {
      this.index = index;
    });
  }

  timeCounter() {
    const oneMin = Duration(seconds: 60);
    timer = Timer.periodic(oneMin, (Timer timer) async {
      await incrementPeriod();
      try {
        print(SharedPreferencesInstance.pref
            .get(SharedPreferencesKeys.UsagePeriod));
      } catch (E) {}
      Rule? rule = Provider.of<AppState>(context, listen: false).rule;
      if (rule != null) {
        checkIfBlocked(rule);
      }
    });
  }

  incrementPeriod() async {
    DateTime now = DateTime.now();
    if (await SharedPreferencesInstance.pref
                .getInt(SharedPreferencesKeys.UsagePeriod) ==
            null ||
        (await SharedPreferencesInstance.pref
                    .getString(SharedPreferencesKeys.CountingPeriodDate) !=
                null &&
            (!DateTime.parse(await SharedPreferencesInstance.pref
                    .getString(SharedPreferencesKeys.CountingPeriodDate)!)
                .isSameDate(now)))) {
      await SharedPreferencesInstance.pref
          .setInt(SharedPreferencesKeys.UsagePeriod, 0);
      await SharedPreferencesInstance.pref
          .setString(SharedPreferencesKeys.CountingPeriodDate, now.toString());
    } else {
      await SharedPreferencesInstance.pref.setInt(
          SharedPreferencesKeys.UsagePeriod,
          SharedPreferencesInstance.pref
                  .getInt(SharedPreferencesKeys.UsagePeriod)! +
              1);
    }
  }

  @override
  void initState() {
    timeCounter();
    try {
      print(SharedPreferencesInstance.pref
          .get(SharedPreferencesKeys.UsagePeriod));
    } catch (E) {}
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sl<RuleProvider>()
          .getStreamRule()
          .map((event) => event.exists ? Rule.fromMap(event) : null),
      initialData: Provider.of<AppState>(context, listen: false).rule,
      builder: (context, state) {
        print(state);
        if (state.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<AppState>(context, listen: false).setRule(state.data!);
          });
          print(state.data!.toString());
          if (checkIfBlocked(state.data!)) {
            return Scaffold(
                body: Center(
              child: Text(
                S.of(context).blockedApp,
                style: TextStyle(fontSize: 20),
              ),
            ));
          }
        }
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 25,
                  offset: const Offset(8, 20)),
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed, // Fixed
                    backgroundColor: Colors.blueGrey
                        .withOpacity(0.7), // <-- This works for fixed
                    showUnselectedLabels: false,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey.shade400,
                    currentIndex: index,
                    onTap: _handleIndexChanged,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: S.of(context).home,
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.search),
                          label: S.of(context).search),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.connected_tv),
                          label: S.of(context).comingSoon),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings),
                          label: S.of(context).settings),
                    ]),
              ),
            ),
          ),
          body: screens[index],
        );
      },
    );
  }
}
