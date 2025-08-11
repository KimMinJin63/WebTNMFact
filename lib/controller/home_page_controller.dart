import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomePageController extends GetxController{
  RxInt selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}