import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/cart_model.dart';
import 'package:mataajer_saudi/app/data/modules/item_model.dart';

class CartController extends GetxController {
  bool loading = false;
  List<CartModel> localCart = <CartModel>[];

  void adddumpData() {
    var item = CartModel(
      quantity: 1,
      itemModel: ItemModel(
        name: "لاب توب",
        image:
            'https://m.media-amazon.com/images/I/71SkQ-Zj79L.__AC_SY300_SX300_QL70_ML2_.jpg',
        description: "لاب توب للبيع",
        categoryUID: "كمبيوتر",
        createdDate: DateTime.now(),
        price: 2500,
      ),
    );

    var item2 = CartModel(
      quantity: 1,
      itemModel: ItemModel(
        name: "تي شيرت - M",
        image:
            r'https://contents.mediadecathlon.com/p2073348/k$1c0d555588837c40b5412a7eaf8f715b/slim-fit-stretch-cotton-fitness-t-shirt.jpg?format=auto&quality=40&f=800x800',
        description: "تي شيرت للبيع",
        categoryUID: "ملابس",
        createdDate: DateTime.now(),
        price: 100,
      ),
    );

    var item3 = CartModel(
      quantity: 1,
      itemModel: ItemModel(
        name: "ساعة يد",
        image:
            r'https://images-na.ssl-images-amazon.com/images/I/71Swqqe7XAL._AC_SX466_.jpg',
        description: "ساعة يد للبيع",
        categoryUID: "ساعات",
        createdDate: DateTime.now(),
        price: 120,
      ),
    );

    localCart.addAll([item, item2, item3]);
  }

  void increaseQuantity(int index) {
    localCart[index].quantity++;
    update();
  }

  void decreaseQuantity(int index) {
    if (localCart[index].quantity > 1) {
      localCart[index].quantity--;
      update();
    }
  }

  void removeItemFromCart({required ItemModel itemModel}) {
    localCart.removeWhere((element) => element.itemModel == itemModel);
    update();
  }

  @override
  void onInit() {
    adddumpData();
    super.onInit();
  }
}
