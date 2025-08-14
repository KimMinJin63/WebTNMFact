import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AdminController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxInt selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}
