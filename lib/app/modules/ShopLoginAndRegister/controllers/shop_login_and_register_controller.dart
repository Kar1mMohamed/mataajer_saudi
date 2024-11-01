import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/constants.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/data/modules/invoice_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/social_media_links.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/data/modules/tap/tap_charge_req.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/app/helpers/payments_helper.dart';
import 'package:mataajer_saudi/app/helpers/seucre_storage.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/check_out_webview.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../utils/log.dart';

class ShopLoginAndRegisterController extends GetxController {
  /// Usally called from the drawer
  bool get isNavigateToRegister =>
      Get.arguments?['isNavigateToRegister'] ?? false;

  MainSettingsController get mainSettingsController =>
      Get.find<MainSettingsController>();

  List<double> get pricesFromSubscriptions =>
      mainSettingsController.subscriptions
          .map((e) => e.yearlyPrice ?? 0)
          .toList();

  final pageController = PageController();
  int pageIndex = 0;

  List<CategoryModule> get categoriesList =>
      mainSettingsController.mainCategories;

  bool loading = false;

  bool showCategories = false;
  bool showPricesTable = true;

  List<String> subTitles = ['تسجيل دخول', 'تسجيل اشتراك'];

  bool showPassword = false;

  final formKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  bool loginRememberMe = false;

  final phoneController = TextEditingController();
  String? shopImageURL;
  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final shopLinkController = TextEditingController();
  List<CategoryModule> choosedCategories = [];
  final shopDescriptionController = TextEditingController();
  final shopKeyWordsController = TextEditingController();
  final avgShippingPriceController = TextEditingController();
  final cuponCodeController = TextEditingController();
  final cuponCodeDetailsController = TextEditingController();

  final facebookController = TextEditingController();
  final twitterController = TextEditingController();
  final instagramController = TextEditingController();
  final snapchatController = TextEditingController();
  final youtubeController = TextEditingController();
  final tiktokController = TextEditingController();

  bool registerIsHasTamara = false;
  bool registerIsHasTabby = false;

  int? shippingFrom;
  int? shippingTo;

  bool get isVersionRelease => mainSettingsController.isVersionRelease;

  void loginRememberMeFunction(bool? value) async {
    loginRememberMe = value ?? false;
    update();
    await GetStorage().write('loginRememberMe', value);
  }

  Future<void> login() async {
    loading = true;
    update();

    try {
      if (loginEmailController.text.isEmpty ||
          loginPasswordController.text.isEmpty) {
        throw 'Please fill all fields'.tr;
      }

      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );

      if (user.user == null) {
        throw 'Error while login'.tr;
      }

      if (!user.user!.emailVerified &&
          !Constants.admins.contains(user.user!.uid)) {
        // throw 'Email not verified';
        log('Email not verified');
        await Get.offAndToNamed(Routes.RESET_PASSWORD,
            arguments: {'isEmailVerify': true});
      }

      if (loginRememberMe) {
        SecureStorageHelper.instance.storage.write(
            key: SecureStorageHelper.LOGIN_EMAIL,
            value: loginEmailController.text);
        SecureStorageHelper.instance.storage.write(
            key: SecureStorageHelper.LOGIN_PASSWORD,
            value: loginPasswordController.text);
      }

      final shopModule = await FirebaseFirestoreHelper.instance
          .getShopModule(user.user!.uid, getSubscriptions: true);

      log('shopModule: $shopModule');

      if (shopModule.userCategory == 'admin-0') {
        goHomeForShop(shopModule);
        return;
      }

      bool isLastSubscriptionExpired = (shopModule.subscriptions ?? []).isEmpty
          ? true
          : ShopModule.isExpired(shopModule.subscriptions!.last.from,
              shopModule.subscriptions!.last.to);

      log('isLastSubscriptionExpired: $isLastSubscriptionExpired');

      if (isLastSubscriptionExpired) {
        await shopModule.updatePrivileges();
        await shopModule.updateValidTill();
      }

      shopModule.token = await user.user!.getIdToken();
      await shopModule.updateShopModule();

      goHomeForShop(shopModule);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        KSnackBar.error('لا يوجد حساب مسجل بهذا البريد الالكتروني');
      } else if (e.code == 'wrong-password') {
        KSnackBar.error('كلمة المرور غير صحيحة');
      }
    } catch (e) {
      log(e);
      KSnackBar.error(e.toString().tr);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> register(ChooseSubscriptionModule sub) async {
    /// THIS METHOD IS TO AVOID APPLE STORE IN-APP PURCHASE
    bool versionTEST = MainSettingsController.find.isVersionRelease;

    if (versionTEST == false) {
      KSnackBar.error('التسجيل غير متاح حاليا');
      return;
    }

    try {
      if (shopImageURL == null) {
        throw 'No image selected';
      }
      if (choosedCategories.isEmpty) {
        throw 'No categories selected';
      }

      loading = true;
      update();

      final regResponse =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (regResponse.user == null) {
        throw 'Error while registering';
      }

      final shopsCount = await FirebaseFirestoreHelper.instance.getShopsCount();

      final shopModule = ShopModule(
        name: shopNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        description: shopDescriptionController.text,
        image: shopImageURL!,
        avgShippingPrice: double.parse(avgShippingPriceController.text),
        avgShippingTime: '$shippingFrom-$shippingTo',
        cuponCode: cuponCodeController.text,
        cuponText: cuponCodeDetailsController.text,
        categoriesUIDs: choosedCategories.map((e) => e.uid!).toList(),
        keywords: shopKeyWordsController.text.split(' '),
        shopLink: shopLinkController.text,
        token: await regResponse.user!.getIdToken(),
        isHasTamara: registerIsHasTamara,
        isHasTabby: registerIsHasTabby,
        shopNumber: shopsCount + 1,
        socialMediaLinks: SocialMediaLinks(
          facebook: facebookController.text,
          twitter: twitterController.text,
          instagram: instagramController.text,
          snapchat: snapchatController.text,
          youtube: youtubeController.text,
          tiktok: tiktokController.text,
        ),
      );

      await FirebaseFirestoreHelper.instance
          .addShop(shopModule, regResponse.user!.uid);

      KSnackBar.show('جاري تحويلك لبوابة الدفع برجاء الانتظار');

      final subscriptionModule = SubscriptionModule(
        from: DateTime.now(),
        to: DateTime.now().add(Duration(days: sub.allowedDays!)),
        subscriptionSettingUID: sub.uid,
      );

      final tapModule = TapChargeReq(
        amount: sub.getPriceByDays,
        description:
            'mataajer-sa subscription for ${sub.name} - ${FirebaseAuth.instance.currentUser?.uid} - ${sub.allowedDays}',
        currency: 'SAR',
        customer: Customer(
          firstName: shopNameController.text,
          email: emailController.text,
        ),
      );

      final paymentReqRes = await PaymentsHelper.sendRequest(tapModule);

      final tapTransactionID = paymentReqRes['id'];
      final redirectURL = paymentReqRes['transaction']['url'];

      final paymentRes = await Get.to(
        () => CheckoutWebview(
          redirectURL,
          'mataajer://m.mataajer-sa.com/success',
          'mataajer://m.mataajer-sa.com/failed',
          'mataajer://m.mataajer-sa.com/cancel',
          onPaymentSuccess: (query) async {
            log('success query: $query');

            final isPaid = await PaymentsHelper.checkIFPaid(tapTransactionID);

            if (!isPaid) {
              KSnackBar.error('حدث خطأ ما الرجاء المحاولة مرة أخرى');
              Get.back(result: {
                'status': 'failed',
              });
              return;
            }

            Get.back(result: {
              'status': 'success',
              'data': query,
            });
          },
          onPaymentCanceled: () {
            Get.back(result: {
              'status': 'canceled',
            });
          },
          onPaymentFailed: () {
            Get.back(result: {
              'status': 'failed',
            });
          },
        ),
      ) as Map<String, dynamic>;

      if (paymentRes['status'] != 'success') {
        log('paymentReqRes: $paymentReqRes');
        throw Exception('paymentReqRes: $paymentReqRes');
      }

      final subscriptionDocUID = await FirebaseFirestoreHelper.instance
          .addSubscription(regResponse.user!.uid, subscriptionModule);

      final invoiceModule = InvoiceModule(
        shopUID: regResponse.user!.uid,
        subscriptionDocUID: subscriptionDocUID,
        subscriptionSettingUID: sub.uid!,
        amount: sub.getPriceByDays,
        tapTransactionID: tapTransactionID,
        date: DateTime.now(),
      );

      await FirebaseFirestoreHelper.instance
          .addInvoiceToShop(regResponse.user!.uid, invoiceModule);

      final finalShopModule = await FirebaseFirestoreHelper.instance
          .getShopModule(regResponse.user!.uid);

      await Future.wait([
        finalShopModule.updateValidTill(),
        finalShopModule.updatePrivileges(),
        if (!regResponse.user!.emailVerified)
          regResponse.user!.sendEmailVerification(),
      ]);

      Get.offAndToNamed(Routes.RESET_PASSWORD,
          arguments: {'isEmailVerify': true});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // log('The password provided is too weak.');
        KSnackBar.error('كلمة المرور ضعيفة');
        // throw 'كلمة المرور ضعيفة';
      } else if (e.code == 'email-already-in-use') {
        // log('The account already exists for that email.');
        KSnackBar.error('البريد الالكتروني مستخدم من قبل');
        // throw 'البريد الالكتروني مستخدم من قبل';
      }
    } catch (e) {
      log(e);
      KSnackBar.error(e.toString().tr);
    } finally {
      loading = false;
      update();
    }
  }

  void pickImageAndUpload() async {
    try {
      final photosPerm = Get.find<MainPermisionsController>().photosPerm;
      if (!await photosPerm.request().isGranted) {
        await photosPerm.request();
        KSnackBar.error('يجب السماح بالوصول للصور');
        throw 'Permission not granted';
      }
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) {
        KSnackBar.error('لم يتم اختيار صورة');
        throw 'No image selected';
      }
      Get.dialog(
        MataajerTheme.loadingWidget,
        barrierDismissible: false,
      );
      final url = await FirebaseStorageFunctions.uploadImage(image);
      shopImageURL = url;
      Get.back(); // dismiss laoding dialog
      KSnackBar.success('تم رفع الصورة بنجاح');
    } catch (e) {
      log(e);
    } finally {
      update();
    }
  }

  void changePageIndex(int index) {
    pageIndex = index;
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    update();
    update(['subTitle']);
  }

  void updateShowCategories() {
    showCategories = !showCategories;
    update(['showCategories']);
  }

  void goHomeForShop(ShopModule shopModule) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      loading = true;
      update();

      if (shopModule.userCategory != null &&
          shopModule.userCategory == 'admin-0') {
        Get.offAndToNamed(Routes.ADMIN_ACTIVE_USERS);
      } else {
        Get.offAndToNamed(Routes.HOME);
      }

      loading = false;
      update();
    }
  }

  void resetPasswordFunction() async {
    if (loginEmailController.text.isEmpty) {
      KSnackBar.error('برجاء ادخال البريد الالكتروني');
      return;
    }
    loading = true;
    update();

    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: loginEmailController.text);

    loading = false;
    update();

    Get.toNamed(Routes.RESET_PASSWORD, arguments: {'isEmailVerify': false});
  }

  Future<void> automaticLogin(String uid) async {
    loading = true;
    update();
    try {
      final shopModule = await FirebaseFirestoreHelper.instance
          .getShopModule(uid, getSubscriptions: true);

      log('shopModule: $shopModule');

      bool isNotAdmin = shopModule.userCategory == null ||
          shopModule.userCategory != 'admin-0';

      if (!FirebaseAuth.instance.currentUser!.emailVerified && isNotAdmin) {
        // throw 'Email not verified';
        log('Email not verified');

        FirebaseAuth.instance.currentUser!.sendEmailVerification();

        await Get.offAndToNamed(Routes.RESET_PASSWORD,
            arguments: {'isEmailVerify': true});
      }

      bool isLastSubscriptionExpired = (shopModule.subscriptions ?? []).isEmpty
          ? true
          : ShopModule.isExpired(shopModule.subscriptions!.last.from,
              shopModule.subscriptions!.last.to);

      log('isLastSubscriptionExpired: $isLastSubscriptionExpired');

      if (isLastSubscriptionExpired) {
        await shopModule.updatePrivileges();
        await shopModule.updateValidTill();
      }
      goHomeForShop(shopModule);
    } catch (e) {
      log('automaticLogin error: $e');
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> fillLoginFileds() async {
    var email = await SecureStorageHelper.instance.storage
        .read(key: SecureStorageHelper.LOGIN_EMAIL);

    var password = await SecureStorageHelper.instance.storage
        .read(key: SecureStorageHelper.LOGIN_PASSWORD);

    if (email != null) {
      loginEmailController.text = email;
    }
    if (password != null) {
      loginPasswordController.text = password;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    loginRememberMe = GetStorage().read('loginRememberMe') ?? false;
    final currentUser = FirebaseAuth.instance.currentUser;

    await Future.wait([
      if (loginRememberMe) fillLoginFileds(),
      if (loginRememberMe && currentUser != null)
        automaticLogin(currentUser.uid),
    ]);

    // if (loginRememberMe) {
    //   await fillLoginFileds();
    // }

    // if (loginRememberMe && currentUser != null) {
    //   await automaticLogin(currentUser.uid);
    // }

    if (isNavigateToRegister) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        changePageIndex(1);
      });
    }

    if (kDebugMode) {
      loginEmailController.text = 'karimo741852@gmail.com';
      loginPasswordController.text = 'karim123';
    }
  }
}
