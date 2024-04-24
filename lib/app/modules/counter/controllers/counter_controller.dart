import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  //TODO: Implement CounterController

  final count = 0.obs;

  final lat = 0.0.obs;
  final long = 0.0.obs;
  final address = 'Address'.obs;
  final city = 'City'.obs;
  final country = ''.obs;
  final province = ''.obs;



  @override
  void onInit() {
    super.onInit();
    // locationPermission();
    getAddress(
      // karachi
      24.8607,
      67.0011,
    );
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void increment() => count.value++;

  void state() {
    count.value++;
  }

  void decrement() {
    if (count.value > 0) {
      count.value--;
    }
  }

  void getAddress(double? latitude, double? longitude) {
    placemarkFromCoordinates(latitude!, longitude!).then((value) {
      address.value = value[0].street.toString();
      city.value = value[0].locality.toString();
      country.value = value[0].country.toString();
      province.value = value[0].administrativeArea.toString();

    });
  }
}
