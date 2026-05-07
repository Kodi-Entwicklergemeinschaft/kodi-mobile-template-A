import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/auth/login/presentation/login_screen.dart';
import 'package:kodi/feat/auth/register/presentation/register_screen.dart';
import 'package:kodi/feat/auth/reset_password/presentation/reset_password_screen.dart';
import 'package:kodi/feat/auth/select_user_type/presentation/select_user_type_screen.dart';
import 'package:kodi/feat/dashboard/presentation/dashoard.dart';
import 'package:kodi/feat/discover/presentation/discover_screen.dart';
import 'package:kodi/feat/home/presentation/home_screen.dart';
import 'package:kodi/feat/intro/welcome/welcome_screen.dart';
import 'package:kodi/feat/listings/data/model/listing_model.dart';
import 'package:kodi/feat/listings/events/presentation/events_screen.dart';
import 'package:kodi/feat/listings/favourite/presentation/fav_screen.dart';
import 'package:kodi/feat/listings/listings/presentation/listings_screen.dart';
import 'package:kodi/feat/mobility/mobility_screen.dart';
import 'package:kodi/feat/mobility/parking/presentation/parking_screen.dart';
import 'package:kodi/feat/user/account/presentation/account_screen.dart';
import 'package:kodi/feat/user/profile/presentation/profile_screen.dart';
import 'package:kodi/feat/user/terms/presentation/terms_conditions_screen.dart';
import 'package:kodi/feat/user/terms/presentation/user_onboard_prefs_screen.dart';
import 'package:shared_dependencies/custom_webview.dart';
import 'package:shared_dependencies/go_router.dart';

import '../../feat/listings/kodi_week/presentation/kodi_week_screen.dart';
import '../../feat/listings/poi/presentation/kodi_poi_screen.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import '../../feat/listings/listing_details_screen.dart';
import '../../feat/listings/search_listings/global_search_listing.dart';
import '../../feat/splash/presentation/splash_screen.dart';
import '../../feat/user/setting/reset_password_profile_screen.dart';
import '../../feat/user/setting/select_language.dart';
import '../../feat/user/setting/select_theme.dart';
import '../../feat/user/setting/setting_screen.dart';
import '../../feat/user/terms/presentation/notification_prefs.dart';

/// Global navigator key for RequestsInspector and navigation
final globalNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Shared paths / urls used across the app
class ScreenPaths {
  static String splash = '/';
  static String welcome = '/welcome';
  static String userType = '/userType';
  static String login = '/login';
  static String register = '/register';
  static String forgotPassword = '/forgotPassword';
  static String changePassword = '/changePassword';
  static String termsConditions = '/termsConditions';
  static String userOnboardPref = '/userOnboardPref';
  static String webView = '/webView';

  // Shell Routes
  static String home = '/home';
  static String discover = '/discover';
  static String events = '/events';
  static String account = '/account';


  // Sub routes
  static String listings = 'listings';
  static String listingDetails = 'listingDetails';
  static String setting = 'setting';
  static String languageSelection = 'languageSelection';
  static String notificationPrefs = 'notificationPrefs';
  static String themeSelection = 'themeSelection';
  static String favouriteScreen = 'favouriteScreen';
  static String globalSearch = 'globalSearch';
  static String profileScreen = "profileScreen";
  static String resetPasswordProfileScreen = "resetPasswordProfileScreen";
  static String mobilityScreen = "mobilityScreen";
  static String parkingScreen = "parkingScreen";
  static String kodiWeekScreen = "kodiWeekScreen";
  static String kodiPoiScreen = "kodiPoiScreen";
}

/// The main application router
final appRouter = GoRouter(
  navigatorKey: globalNavKey,
  debugLogDiagnostics: kDebugMode,
  initialLocation: ScreenPaths.splash,
  routes: [
    AppRoute(ScreenPaths.splash, (_) => SplashScreen()),
    AppRoute(ScreenPaths.welcome, (s) => Welcome(isGoToLoginScreen: s.extra as bool?,)),
    AppRoute(ScreenPaths.webView, (s) {
      final args = s.extra as List<Object?>;
      return CustomWebViewScreen(
        url: args[0] as String,
        title: args.length > 1 ? args[1] as String? : null,
      );
    }),
    AppRoute(ScreenPaths.userType, (s) => SelectUserType(isHomeUserSelected: s.extra as bool?), keepAlive: true),
    AppRoute(ScreenPaths.login, (_) => Login(), keepAlive: true),
    AppRoute(ScreenPaths.register, (_) => Register(), keepAlive: true),
    AppRoute(
      ScreenPaths.forgotPassword,
      (_) => ResetPassword(),
      keepAlive: true,
    ),
    AppRoute(
      ScreenPaths.termsConditions,
      (_) => TermsConditions(key: UniqueKey()),
      keepAlive: true,
    ),
    AppRoute(
      ScreenPaths.userOnboardPref,
      (_) => UserOnboardPrefs(),
      keepAlive: true,
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return DashboardScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            AppRoute(
              ScreenPaths.home,
              (_) => const HomeScreen(),
              routes: [
                AppRoute(ScreenPaths.listingDetails, (s) {
                  final args = s.extra as List<Object?>;
                  return ListingDetailsScreen(
                    event: args[0] as ListingModel,
                    headerBackgroundColor: args.length > 1
                        ? args[1] as Color?
                        : null,
                    isShopping: args.length > 2 ? args[2] as bool? : false,
                    searchedText: args.length > 3 ? args[3] as String? : null,
                    isKodiWeekListing: args.length > 4 ? args[4] as bool? : false,
                  );
                }),
                AppRoute(ScreenPaths.mobilityScreen, (_) {
                  return MobilityScreen();
                }, routes: [
                  AppRoute(ScreenPaths.parkingScreen, (_) {
                    return ParkingScreen();
                  })
                ]),
                AppRoute(ScreenPaths.kodiWeekScreen, (s) {
                  final category = s.extra as CategoryModel;
                  return KodiWeekScreen(category: category);
                }, routes: [
                  AppRoute(ScreenPaths.kodiPoiScreen, (s) {
                    final category = s.extra as CategoryModel;
                    return KodiPOIScreen(category: category);
                  }, routes: [
                    AppRoute(ScreenPaths.listingDetails, (s) {
                      final args = s.extra as List<Object?>;
                      return ListingDetailsScreen(
                        event: args[0] as ListingModel,
                        headerBackgroundColor:
                            args.length > 1 ? args[1] as Color? : null,
                        isShopping:
                            args.length > 2 ? args[2] as bool? : false,
                        searchedText:
                            args.length > 3 ? args[3] as String? : null,
                        isKodiWeekListing: args.length > 4
                            ? args[4] as bool?
                            : false,
                      );
                    }),
                  ]),
                ]),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            AppRoute(
              ScreenPaths.discover,
              (_) => const DiscoverScreen(),
              routes: [
                AppRoute(ScreenPaths.globalSearch, (s) {
                  final args = s.extra as List<Object?>;
                  return GlobalSearchListing(
                    searchTerm: args[0] as String? ?? '',
                    key: args.length > 1 ? args[1] as Key? : null,
                  );
                }),
                AppRoute(ScreenPaths.listings, (s) {
                  final args = s.extra as List<Object?>;
                  return ListingsScreen(
                    categorySlug: args[0] as String,
                    selectedSubCategoryId: args.length > 1
                        ? args[1] as String?
                        : null,
                    key: args.length > 2 ? args[2] as Key? : null,
                  );
                }),
                AppRoute(ScreenPaths.kodiWeekScreen, (s) {
                  final category = s.extra as CategoryModel;
                  return KodiWeekScreen(category: category);
                }, routes: [
                  AppRoute(ScreenPaths.kodiPoiScreen, (s) {
                    final category = s.extra as CategoryModel;
                    return KodiPOIScreen(category: category);
                  }, routes: [
                    AppRoute(ScreenPaths.listingDetails, (s) {
                      final args = s.extra as List<Object?>;
                      return ListingDetailsScreen(
                        event: args[0] as ListingModel,
                        headerBackgroundColor:
                            args.length > 1 ? args[1] as Color? : null,
                        isShopping:
                            args.length > 2 ? args[2] as bool? : false,
                        searchedText:
                            args.length > 3 ? args[3] as String? : null,
                        isKodiWeekListing: args.length > 4
                            ? args[4] as bool?
                            : false,
                      );
                    }),
                  ]),
                  AppRoute(ScreenPaths.listingDetails, (s) {
                    final args = s.extra as List<Object?>;
                    return ListingDetailsScreen(
                      event: args[0] as ListingModel,
                      headerBackgroundColor:
                      args.length > 1 ? args[1] as Color? : null,
                      isShopping:
                      args.length > 2 ? args[2] as bool? : false,
                      searchedText:
                      args.length > 3 ? args[3] as String? : null,
                      isKodiWeekListing: args.length > 4 ? args[4] as bool? : false,
                      hideImage: args.length > 5 ? args[5] as bool? ?? false : false,
                    );
                  }),
                ]),
                AppRoute(ScreenPaths.listingDetails, (s) {
                  final args = s.extra as List<Object?>;
                  return ListingDetailsScreen(
                    event: args[0] as ListingModel,
                    headerBackgroundColor: args.length > 1 ? args[1] as Color? : null,
                    isShopping: args.length > 2 ? args[2] as bool? : false,
                    searchedText: args.length > 3 ? args[3] as String? : null,
                    isKodiWeekListing: args.length > 4 ? args[4] as bool? : false,
                    hideImage: args.length > 5 ? args[5] as bool? ?? false : false,
                  );
                }),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            AppRoute(
              ScreenPaths.events,
              (_) => const EventsScreen(),
              routes: [
                AppRoute(ScreenPaths.listingDetails, (s) {
                  final args = s.extra as List<Object?>;
                  return ListingDetailsScreen(
                    event: args[0] as ListingModel,
                    headerBackgroundColor: args.length > 1
                        ? args[1] as Color?
                        : null,
                    isShopping: args.length > 2 ? args[2] as bool? : false,
                    searchedText: args.length > 3 ? args[3] as String? : null,
                    isKodiWeekListing: args.length > 4
                        ? args[4] as bool?
                        : false,
                  );
                }),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            AppRoute(
              ScreenPaths.account,
              (_) => const AccountScreen(),
              routes: [
                AppRoute(ScreenPaths.profileScreen, (_) => ProfileScreen()),
                AppRoute(
                  ScreenPaths.setting,
                  (_) => SettingsScreen(),
                  routes: [
                    AppRoute(
                      ScreenPaths.languageSelection,
                      (_) => LanguageSelectionScreen(),
                    ),
                    AppRoute(
                      ScreenPaths.themeSelection,
                      (_) => ThemeSelectionScreen(),
                    ),
                    AppRoute(
                      ScreenPaths.notificationPrefs,
                      (_) => NotificationPrefs(),
                    ),
                    AppRoute(
                      ScreenPaths.resetPasswordProfileScreen,
                          (_) => ResetPasswordProfileScreen(),
                    ),
                  ],
                ),
                AppRoute(
                  ScreenPaths.favouriteScreen,
                  (s) => FavScreen(
                    categoryId: s.extra is String ? s.extra as String : null,
                  ),
                  routes: [
                    AppRoute(ScreenPaths.listingDetails, (s) {
                      final args = s.extra as List<Object?>;
                      return ListingDetailsScreen(
                        event: args[0] as ListingModel,
                        headerBackgroundColor: args.length > 1
                            ? args[1] as Color?
                            : null,
                        isShopping: args.length > 2 ? args[2] as bool? : false,
                        searchedText: args.length > 3 ? args[3] as String? : null,
                        isKodiWeekListing: args.length > 4 ? args[4] as bool? : false,
                        hideImage: args.length > 5 ? args[5] as bool? ?? false : false,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),
  ),
);

class AppRoute extends GoRoute {
  AppRoute(
    String path,
    Widget Function(GoRouterState s) builder, {
    List<GoRoute> routes = const [],
    this.useFade = false,
    this.keepAlive = false,
  }) : super(
         path: path,
         routes: routes,
         pageBuilder: (context, state) {
           final pageContent = Scaffold(
             body: builder(state),
             resizeToAvoidBottomInset: false,
           );

           if (keepAlive) {
             return CustomTransitionPage(
               key: state.pageKey,
               child: pageContent,
               transitionsBuilder: (_, __, ___, child) => child,
             );
           }

           if (useFade) {
             return CustomTransitionPage(
               key: state.pageKey,
               child: pageContent,
               transitionsBuilder: (context, animation, _, child) {
                 return FadeTransition(opacity: animation, child: child);
               },
             );
           }

           return CupertinoPage(key: state.pageKey, child: pageContent);
         },
       );

  final bool useFade;
  final bool keepAlive;
}


