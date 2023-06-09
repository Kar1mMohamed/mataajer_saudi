import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mataajer_saudi/app/controllers/main_permisions_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/firebase_storage.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class ShopLoginAndRegisterController extends GetxController {
  /// Usally called from the drawer
  bool get isNavigateToRegister =>
      Get.arguments?['isNavigateToRegister'] ?? false;

  final mainSettingsController = Get.find<MainSettingsController>();

  List<double> get pricesFromSubscriptions =>
      mainSettingsController.subscriptions.map((e) => e.yearlyPrice!).toList();

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

  String? shopImageURL;
  final shopNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final shopLinkController = TextEditingController();
  List<CategoryModule> choosedCategories = [];
  final shopDescriptionController = TextEditingController();
  final shopKeyWordsController = TextEditingController();
  List<String> keywords = [];
  int avgFromShippingPrice = 0;
  int avgToShippingPrice = 0;
  final avgShippingPriceController = TextEditingController();
  final cuponCodeController = TextEditingController();
  final cuponCodeDetailsController = TextEditingController();

  int? shippingFrom;
  int? shippingTo;

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

      // if (!user.user!.emailVerified) {
      //   // throw 'Email not verified';
      //   print('Email not verified');
      //   await Get.offAndToNamed(Routes.RESET_PASSWORD,
      //       arguments: {'isEmailVerify': true});
      // }

      final userModule =
          await FirebaseFirestoreHelper.instance.getShopModule(user.user!.uid);

      print('userModule: $userModule');

      await goHomeForShop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
        // throw 'لا يوجد حساب مسجل بهذا البريد الالكتروني';
        KSnackBar.error('لا يوجد حساب مسجل بهذا البريد الالكتروني');
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        // throw 'كلمة المرور غير صحيحة';
        KSnackBar.error('كلمة المرور غير صحيحة');
      }
    } catch (e) {
      print(e);
      KSnackBar.error(e.toString().tr);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> register(ChooseSubscriptionModule sub) async {
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

      await regResponse.user!.sendEmailVerification();

      final shopModule = ShopModule(
        name: shopNameController.text,
        email: emailController.text,
        description: shopDescriptionController.text,
        image: shopImageURL!,
        avgShippingPrice: double.parse(avgShippingPriceController.text),
        avgShippingTime: '$avgFromShippingPrice-$avgToShippingPrice',
        cuponCode: cuponCodeController.text,
        cuponText: cuponCodeDetailsController.text,
        categoriesUIDs: choosedCategories.map((e) => e.uid!).toList(),
      );

      await FirebaseFirestoreHelper.instance
          .addShop(shopModule, regResponse.user!.uid);

      final subscriptionModule = SubscriptionModule(
        from: DateTime.now(),
        to: DateTime.now().add(Duration(days: sub.allowedDays!)),
        subscriptionUID: sub.uid!,
      );

      await FirebaseFirestoreHelper.instance
          .addSubscription(regResponse.user!.uid, subscriptionModule);

      await Get.offAndToNamed(Routes.RESET_PASSWORD,
          arguments: {'isEmailVerify': true});
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        throw 'كلمة المرور ضعيفة';
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        throw 'البريد الالكتروني مستخدم من قبل';
      }
    } catch (e) {
      print(e);
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
      print(e);
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

  Future<void> goHomeForShop() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      loading = true;
      update();

      final shopModule =
          await FirebaseFirestoreHelper.instance.getShopModule(currentUser.uid);

      if (shopModule.userCategory != null &&
          shopModule.userCategory!.contains('admin')) {
        Get.offAndToNamed(Routes.ADMIN_ACTIVE_USERS);
      } else {
        Get.offAndToNamed(Routes.HOME);
      }

      loading = false;
      update();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await goHomeForShop();

    if (isNavigateToRegister) {
      await Future.delayed(const Duration(milliseconds: 50));
      changePageIndex(1);
    }

    // if (kDebugMode) {
    loginEmailController.text = 'karimo741852@gmail.com';
    loginPasswordController.text = 'karim123';
    // }
  }
}
