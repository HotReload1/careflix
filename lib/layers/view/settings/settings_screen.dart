import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/layers/view/settings/widgets/day_night_button.dart';
import 'package:careflix/layers/view/settings/widgets/settings_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/routing/route_path.dart';
import '../../../generated/l10n.dart';
import '../../../injection_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  signOut(BuildContext context) async {
    await Future.wait(
        [FirebaseAuth.instance.signOut(), sl.reset(dispose: false)]);
    initInjection();
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RoutePaths.LogIn, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Styles.colorPrimary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    FirebaseAuth.instance.currentUser!.email!,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => signOut(context),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).logout,
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                        size: 25,
                      )
                    ],
                  ),
                )
              ],
            ),
            CommonSizes.vBigSpace,
            SettingsCard(
                icon: Icons.nightlight_round,
                title: S.of(context).appTheme,
                child: DayNightButton(),
                fun: (value) => {}),
            CommonSizes.vSmallSpace,
            SettingsCard(
              icon: Icons.language,
              title: S.of(context).appLanguage,
              fun: () => {
                Navigator.of(context).pushNamed(RoutePaths.AppLanguageScreen)
              },
            ),
            CommonSizes.vSmallSpace,
            SettingsCard(
              icon: Icons.family_restroom,
              title: S.of(context).parentalControl,
              fun: () => {
                Navigator.of(context)
                    .pushNamed(RoutePaths.ParentalControlScreen)
              },
            ),
          ],
        ),
      ),
    );
  }
}
