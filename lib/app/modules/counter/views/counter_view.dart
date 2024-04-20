import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:untitled/models/location.dart';

import '../controllers/counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final controller = Get.put(CounterController());

  Future<void> locationService() async {
    Location location = Location();
    LocationData locData;

    PermissionStatus permissionStatus;
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    locData = await location.getLocation();
    print(locData.latitude);
    print(locData.longitude);

    setState(() {
      UserLocation.lat = locData.latitude!;
      UserLocation.long = locData.longitude!;
      controller.getAddress(UserLocation.lat, UserLocation.long);
    });

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      locData = await location.getLocation();
      print(locData.latitude);
      print(locData.longitude);

      setState(() {
        UserLocation.lat = locData.latitude!;
        UserLocation.long = locData.longitude!;
        controller.getAddress(UserLocation.lat, UserLocation.long);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    locationService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
        title:   Obx(() => Text(
          '${controller.count}',
          style: Theme.of(context).textTheme.displayMedium,
        )),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // address: Text('${controller.address}'),
          // city: Text('${controller.city}'),
          children: <Widget>[
            // address: Text('${controller.address}'),

            Text('address ${controller.address}'),
            Text('city ${controller.city}'),
            Text('country ${controller.country}'),
            Text('lat ${controller.lat}'),
            Text('long ${controller.lat}'),


            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(() => Text(
                  '${controller.count}',
                  style: Theme.of(context).textTheme.displayMedium,
                )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              controller.increment();
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {
              controller.decrement();
            },
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

// class CounterViewPage extends GetView<CounterController> {
//   const CounterViewPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider <CounterModel>(
//       create: (context) => CounterModel(),
//       child: Consumer<CounterModel>(
//         builder: (context, model, child) {
//           return Scaffold(
//             appBar: AppBar(
//               iconTheme:  IconThemeData(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
//               title: const Text('Counter'),
//               centerTitle: true,
//             ),
//             body: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   const Text(
//                     'You have pushed the button this many times:',
//                   ),
//                   Text(
//                     '${model.counter}',
//                     style: Theme.of(context).textTheme.headlineMedium,
//                   ),
//                 ],
//               ),
//             ),
//             floatingActionButton: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 FloatingActionButton(
//                   heroTag: 'btn1',
//                   onPressed: () {
//                     model.increment();
//                   },
//                   tooltip: 'Increment',
//                   child: const Icon(Icons.add),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 FloatingActionButton(
//                   heroTag: 'btn2',
//                   onPressed: () {
//                     model.decrement();
//                   },
//                   tooltip: 'Decrement',
//                   child: const Icon(Icons.remove),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
