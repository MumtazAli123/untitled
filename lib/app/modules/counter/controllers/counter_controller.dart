import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';

class CounterController extends GetxController {
  //TODO: Implement CounterController

  final count = 0.obs;

  final lat = 0.0.obs;
  final long = 0.0.obs;
  final address = 'Address'.obs;
  final city = 'City'.obs;
  final country = ''.obs;
  final province = ''.obs;


  // permissionStatus = await location.hasPermission();
  // void locationPermission() async {
  //   loc.Location location = loc.Location();
  //   PermissionStatus permissionStatus;
  //   bool serviceEnabled;
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   permissionStatus = await location.hasPermission();
  //   if (permissionStatus == PermissionStatus.denied) {
  //     permissionStatus = await location.requestPermission();
  //     if (permissionStatus != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  // }

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

  void decrement() => count.value--;

  void getAddress(double? latitude, double? longitude) {
    placemarkFromCoordinates(latitude!, longitude!).then((value) {
      address.value = value[0].street.toString();
      city.value = value[0].locality.toString();
      country.value = value[0].country.toString();
      province.value = value[0].administrativeArea.toString();

    });
  }
}
