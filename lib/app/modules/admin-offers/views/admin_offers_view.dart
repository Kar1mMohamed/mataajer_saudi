import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/preview_offer_dialog.dart';
import '../../../data/assets.dart';
import '../../../widgets/back_button.dart';
import '../controllers/admin_offers_controller.dart';

class AdminOffersView extends GetView<AdminOffersController> {
  const AdminOffersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: GetBuilder<AdminOffersController>(
        builder: (_) {
          if (controller.loading) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: MataajerTheme.loadingWidget,
            );
          }
          return Column(
            children: [
              search(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      itemCount: controller.offers.length,
                      separatorBuilder: (context, index) =>
                          const Divider(thickness: 0.5),
                      itemBuilder: (context, index) {
                        return GetBuilder<AdminOffersController>(
                            id: 'offer-card-$index',
                            builder: (_) {
                              if (controller.loading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListTile(
                                onTap: () => Get.dialog(
                                  PreviewOfferDialog(
                                    offerModule: controller.offers[index],
                                  ),
                                ),
                                leading: CircleAvatar(
                                  radius: 22.r,
                                  backgroundImage: NetworkImage(
                                      controller.offers[index].imageURL),
                                ),
                                title: Text(
                                  controller.offers[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                                titleAlignment: ListTileTitleAlignment.center,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(controller
                                        .offers[index].categories.first.name),
                                    Text(controller.offers[index].cuponCode ??
                                        ''),
                                  ],
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    controller.loading = true;
                                    controller.updateOfferCard(index);

                                    await controller
                                        .deleteOffer(controller.offers[index]);
                                    await controller.getOffers();

                                    controller.loading = false;
                                    controller.updateOfferCard(index);
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              );
                            });
                      },
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('العروض',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500)),
      centerTitle: true,
      toolbarHeight: 50.h,
      leading: Transform.translate(
        offset: const Offset(-10, 0),
        child: const CustomBackButton(),
      ),
      leadingWidth: 50.w,
    );
  }

  Widget search() {
    return TextField(
      onChanged: controller.search,
      style: TextStyle(
        fontSize: 13.sp,
        color: const Color.fromARGB(255, 119, 119, 119),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(right: 10.0.sp, bottom: 40.0.sp),
        prefixIcon: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Image.asset(Assets.searchIcon),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 30.spMin,
          minHeight: 30.spMax,
        ),
        fillColor: Colors.grey[200],
        hintText: '  ابحث عن العروض',
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: const Color.fromARGB(255, 119, 119, 119),
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 219, 219, 219), width: 1.0),
          borderRadius: BorderRadius.circular(30.0.r),
        ),
      ),
    );
  }
}
