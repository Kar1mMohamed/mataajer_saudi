// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

import '../modules/AddAd/bindings/add_ad_binding.dart';
import '../modules/AddAd/views/add_ad_view.dart';
import '../modules/ChooseSubscription/bindings/choose_subscription_binding.dart';
import '../modules/ChooseSubscription/views/choose_subscription_view.dart';
import '../modules/OnBoarding/bindings/on_boarding_binding.dart';
import '../modules/OnBoarding/views/on_boarding_view.dart';
import '../modules/ResetPassword/bindings/reset_password_binding.dart';
import '../modules/ResetPassword/views/reset_password_view.dart';
import '../modules/ShopAccount/bindings/shop_account_binding.dart';
import '../modules/ShopAccount/views/shop_account_view.dart';
import '../modules/ShopCustomersNotifications/bindings/shop_customers_notifications_binding.dart';
import '../modules/ShopCustomersNotifications/views/shop_customers_notifications_view.dart';
import '../modules/ShopLoginAndRegister/bindings/shop_login_and_register_binding.dart';
import '../modules/ShopLoginAndRegister/views/shop_login_and_register_view.dart';
import '../modules/add-offer/bindings/add_offer_binding.dart';
import '../modules/add-offer/views/add_offer_view.dart';
import '../modules/add-popup-ad/bindings/add_popup_ad_binding.dart';
import '../modules/add-popup-ad/views/add_popup_ad_view.dart';
import '../modules/admin-active-users/bindings/admin_active_users_binding.dart';
import '../modules/admin-active-users/views/admin_active_users_view.dart';
import '../modules/admin_notification/bindings/admin_notification_binding.dart';
import '../modules/admin_notification/views/admin_notification_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/payments-redirect/bindings/payments_redirect_binding.dart';
import '../modules/payments-redirect/views/payments_redirect_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ON_BARDING,
      page: () => const OnBoardingView(),
      binding: OnBoardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
      transition: Transition.cupertino,
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
    GetPage(
      name: _Paths.SHOP_CUSTOMERS_NOTIFICATIONS,
      page: () => const ShopCustomersNotificationsView(),
      binding: ShopCustomersNotificationsBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_ACTIVE_USERS,
      page: () => const AdminActiveUsersView(),
      binding: AdminActiveUsersBinding(),
    ),
    GetPage(
      name: _Paths.CHOOSE_SUBSCRIPTION,
      page: () => ChooseSubscriptionView(),
      binding: ChooseSubscriptionBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_NOTIFICATION,
      page: () => const AdminNotificationView(),
      binding: AdminNotificationBinding(),
    ),
    GetPage(
      name: _Paths.ADD_POPUP_AD,
      page: () => const AddPopupAdView(),
      binding: AddPopupAdBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENTS_REDIRECT,
      page: () => const PaymentsRedirectView(),
      binding: PaymentsRedirectBinding(),
    ),
    GetPage(
      name: _Paths.ADD_OFFER,
      page: () => const AddOfferView(),
      binding: AddOfferBinding(),
    ),
  ];
}
