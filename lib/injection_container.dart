import 'package:careflix/core/app/state/app_state.dart';
import 'package:careflix/core/theme/theme_provider.dart';
import 'package:careflix/l10n/local_provider.dart';
import 'package:careflix/layers/data/data_provider/auth_provider.dart';
import 'package:careflix/layers/data/data_provider/coming_soon_provider.dart';
import 'package:careflix/layers/data/data_provider/lists_provider.dart';
import 'package:careflix/layers/data/data_provider/profile_provider.dart';
import 'package:careflix/layers/data/data_provider/rule_provider.dart';
import 'package:careflix/layers/data/data_provider/search_provider.dart';
import 'package:careflix/layers/data/data_provider/show_video_provider.dart';
import 'package:careflix/layers/data/repository/auth_repository.dart';
import 'package:careflix/layers/data/repository/coming_soon_repository.dart';
import 'package:careflix/layers/data/repository/lists_repository.dart';
import 'package:careflix/layers/data/repository/profile_repository.dart';
import 'package:careflix/layers/data/repository/rule_repository.dart';
import 'package:careflix/layers/data/repository/search_repository.dart';
import 'package:careflix/layers/data/repository/show_video_repository.dart';
import 'package:careflix/layers/logic/auth/auth_cubit.dart';
import 'package:careflix/layers/logic/coming_soon/coming_soon_cubit.dart';
import 'package:careflix/layers/logic/profile/profile_cubit.dart';
import 'package:careflix/layers/logic/search/search_cubit.dart';
import 'package:careflix/layers/logic/show_lists/show_lists_cubit.dart';
import 'package:careflix/layers/logic/show_video/show_video_cubit.dart';
import 'package:careflix/layers/view/search_screen/filters/show_filter_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initInjection() {
  //cubit
  sl.registerLazySingleton(() => ShowFilterCubit());
  sl.registerLazySingleton(() => AuthCubit());
  sl.registerLazySingleton(() => ProfileCubit());
  sl.registerLazySingleton(() => ShowListsCubit());
  sl.registerLazySingleton(() => SearchCubit());
  sl.registerLazySingleton(() => ComingSoonCubit());
  sl.registerLazySingleton(() => ShowVideoCubit());

  //Provider
  sl.registerLazySingleton(() => ThemeProvider());
  sl.registerLazySingleton(() => LocaleProvider());
  sl.registerLazySingleton(() => AppState());

  //repos
  sl.registerLazySingleton(() => AuthRepository(sl()));
  sl.registerLazySingleton(() => ProfileRepository(sl()));
  sl.registerLazySingleton(() => ListsRepository(sl()));
  sl.registerLazySingleton(() => SearchRepository(sl()));
  sl.registerLazySingleton(() => ComingSoonRepository(sl()));
  sl.registerLazySingleton(() => ShowVideoRepository(sl()));
  sl.registerLazySingleton(() => RuleRepository(sl()));

  //data_provider
  sl.registerLazySingleton(() => AuthProvider());
  sl.registerLazySingleton(() => ProfileProvider());
  sl.registerLazySingleton(() => ListsProvider());
  sl.registerLazySingleton(() => SearchProvider());
  sl.registerLazySingleton(() => ComingSoonProvider());
  sl.registerLazySingleton(() => ShowVideoProvider());
  sl.registerLazySingleton(() => RuleProvider());
}
