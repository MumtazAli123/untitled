// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:untitled/widgets/mix_widgets.dart';

import '../controllers/auth_controller.dart';



class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {

  final controller = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // qrCode
  TextEditingController qrCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              elevation: 0.0,
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('AuthView'),
                background: Image.asset(
                  'assets/images/back.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Container(
            padding:  EdgeInsets.all(20.0),
            width: 450,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                wText('QrCode Scanner', color: Colors.green),
                // qr image
               Obx(() => QrImageView(
                 backgroundColor: Colors.white,
                 data: controller.qrCode.value,
                 version: QrVersions.auto,
                 size: 200.0,
                )),

                SizedBox(height: 20.0),
                TextFormField(
                  controller: qrCodeController,
                  onChanged: (value) {
                    controller.qrCode.value = value;
                  },

                  decoration: InputDecoration(
                    labelText: 'QrCode',
                    hintText: 'Enter your QrCode',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    // scan qr code
                   controller.scanQr();

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: wText('Login', color: Colors.white),
                ),
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    wText('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        // Get.to(() => const RegistrationView());
                        Get.toNamed('/register');
                      },
                      child: wText('Registration', color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}


// class AuthView extends GetView<AuthController> {
//   const AuthView({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme:  IconThemeData(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
//         title: const Text('AuthView'),
//         centerTitle: true,
//       ),
//       body:  Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             wText('QrCode Scanner', color: Colors.green),
//             wText('Login', color: Colors.green),
//             SizedBox(height: 20.0),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 hintText: 'Enter your email',
//                 prefixIcon: Icon(Icons.email),
//               ),
//             ),
//             SizedBox(height: 20.0),
//             TextFormField(
//               decoration: InputDecoration(
//                 disabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Colors.red,
//                   ),
//                 ),
//                 labelText: 'Password',
//                 hintText: 'Enter your password',
//                 prefixIcon: Icon(Icons.lock),
//               ),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: () {
//                 Get.to(() => const RegistrationView());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//               child: wText('Registration', color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
