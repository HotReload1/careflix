import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/theme/theme_provider.dart';
import 'package:careflix/l10n/l10n.dart';
import 'package:careflix/l10n/local_provider.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';

class AppLanguageScreen extends StatelessWidget {
  const AppLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appLanguage),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Builder(
          builder: (context) {
            final provider = Provider.of<LocaleProvider>(context, listen: true);
            return GridView.builder(
              physics: const ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: L10n.all.length,
              itemBuilder: (context, index) {
                Locale locale = L10n.all[index];
                return GestureDetector(
                  onTap: () {
                    provider.changeLanguageWithoutRestart(locale);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: provider.locale == locale
                          ? Styles.colorPrimary
                          : Styles.colorPrimary.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CountryFlag.fromCountryCode(
                          L10n.getFlag(locale.toString()),
                          height: 62,
                          width: 76,
                        ),
                        CommonSizes.vBigSpace,
                        Text(
                          L10n.getLanguageName(locale.toString()),
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
