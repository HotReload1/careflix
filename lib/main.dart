import 'package:careflix/core/app/state/app_state.dart';
import 'package:careflix/core/configuration/styles.dart';
import 'package:careflix/core/routing/router.dart';
import 'package:careflix/core/services/assets_loader.dart';
import 'package:careflix/core/shared_preferences/shared_preferences_instance.dart';
import 'package:careflix/core/theme/theme_provider.dart';
import 'package:careflix/injection_container.dart';
import 'package:careflix/l10n/l10n.dart';
import 'package:careflix/layers/view/intro/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'core/routing/route_path.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'l10n/local_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initInjection();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesInstance().init();
  await sl<ThemeProvider>().initThemeMode();
  await sl<LocaleProvider>().fetchLocale();
  AssetsLoader.initAssetsLoaders();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sl<LocaleProvider>()),
        ChangeNotifierProvider(create: (context) => sl<ThemeProvider>()),
        ChangeNotifierProvider(create: (context) => sl<AppState>()),
      ],
      builder: (context, state) {
        final localizationProvider = Provider.of<LocaleProvider>(context);
        final themeProvider = Provider.of<ThemeProvider>(context);
        return ScreenUtilInit(
          designSize: Size(1080, 1920),
          minTextAdapt: true,
          useInheritedMediaQuery: true,
          child: MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Styles.colorPrimary, brightness: Brightness.dark),
              useMaterial3: true,
              iconTheme: IconThemeData(color: Colors.white),
              appBarTheme: AppBarTheme(backgroundColor: Styles.backgroundColor),
              scaffoldBackgroundColor: Styles.backgroundColor,
              inputDecorationTheme: Styles.inputDecorationStyle
                  .copyWith(fillColor: Styles.backgroundColor),
            ),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              inputDecorationTheme: Styles.inputDecorationStyle.copyWith(
                  fillColor: Theme.of(context).scaffoldBackgroundColor),
            ),
            scrollBehavior: ScrollConfiguration.of(context).copyWith(
              physics: const BouncingScrollPhysics(),
            ),
            supportedLocales: L10n.all,
            locale: localizationProvider.locale,
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: RoutePaths.SplashScreen,
          ),
        );
      },
    );
  }
}
