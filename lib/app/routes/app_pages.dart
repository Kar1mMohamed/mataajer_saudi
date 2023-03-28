import 'package:get/get.dart';

import '../modules/AddAd/bindings/add_ad_binding.dart';
import '../modules/AddAd/views/add_ad_view.dart';
import '../modules/ResetPassword/bindings/reset_password_binding.dart';
import '../modules/ResetPassword/views/reset_password_view.dart';
import '../modules/ShopAccount/bindings/shop_account_binding.dart';
import '../modules/ShopAccount/views/shop_account_view.dart';
import '../modules/ShopLoginAndRegister/bindings/shop_login_and_register_binding.dart';
import '../modules/ShopLoginAndRegister/views/shop_login_and_register_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ADD_AD;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_LOGIN_AND_REGISTER,
      page: () => const ShopLoginAndRegisterView(),
      binding: ShopLoginAndRegisterBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.SHOP_ACCOUNT,
      page: () => const ShopAccountView(),
      binding: ShopAccountBinding(),
    ),
    GetPage(
      name: _Paths.ADD_AD,
      page: () => const AddAdView(),
      binding: AddAdBinding(),
    ),
  ];
}
