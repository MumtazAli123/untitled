// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/button/gf_button_bar.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:untitled/app/modules/products/views/products_edit_view.dart';
import 'package:untitled/app/modules/products/views/products_page_view.dart';
import 'package:untitled/app/modules/products/views/upload_products_view.dart';

import '../../../../models/products_model.dart';
import '../../../../widgets/mix_widgets.dart';
import '../controllers/products_controller.dart';

class ShowProductsView extends StatefulWidget {
   const ShowProductsView({super.key});

  @override
  State<ShowProductsView> createState() => _ShowProductsViewState();
}

class _ShowProductsViewState extends State<ShowProductsView> {
  final ProductsController controller = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        onPressed: () {
          Get.to(() => UploadProductsView());
        },
        label: aText('Upload', color: Colors.white),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed('/profile');

            },
            icon: Icon(Icons.arrow_back)
        ),
        title: Text('Your Products'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 48.0),
        child: _buildProductList(),
      ),
    );
  }

  _buildProductList() {
    return Obx(() {
      if (controller.products.isEmpty) {
        return Center(child: Text('No data'));
      }
      return ListView.builder(
        itemCount: controller.products.length,
        itemBuilder: (context, index) {
          ProductsModel model = controller.products[index];
          return wBuildVehicleItem(model);
        },
      );
    });
  }

  wBuildVehicleItem(ProductsModel model) {
    return GFCard(
      title: GFListTile(
        color: Colors.orange,
        titleText: model.pName,
        // discount price show after discount price
        subTitleText: model.pDiscountType == "Percentage"
            // show price  and cross after show discount price
            ? "PRICE: ${model.pPrice} - ${model.pDiscount}% = ${double.parse(model.pPrice!) - (double.parse(model.pPrice!) * double.parse(model.pDiscount!) / 100)}"
            : "PRICE: ${model.pPrice} - ${model.pDiscount} = ${double.parse(model.pPrice!) - double.parse(model.pDiscount!)}",
      ),
      image: Image.network(model.pImages!, fit: BoxFit.fill, width: double.infinity, height: 300,),
      showImage: true,
      content: Table(
        children: [
          // price
          TableRow(children: [
            Text('Price:'),
            model.pDiscountType == "Percentage"
                ? aText(
              "${double.parse(model.pPrice!) - (double.parse(model.pPrice!) * double.parse(model.pDiscount!) / 100)}",
            )
                : aText(
              "${double.parse(model.pPrice!) - double.parse(model.pDiscount!)}",
            ),
          ]),
          TableRow(children: [
            Text('Brand:'),
            Text(model.pBrand!),
          ]),
          TableRow(children: [
            Text('Quantity:'),
            Text(model.pQuantity!),
          ]),
          TableRow(children: [
            Text('Category:'),
            Text(model.pCategory!),
          ]),
          TableRow(children: [
            Text('Condition:'),
            Text(model.pCondition!),
          ]),
          TableRow(children: [
            Text('Delivery:'),
            Text(model.pDelivery!),
          ]),
          TableRow(children: [
            Text('Return:'),
            Text(model.pReturn!),
          ]),
          TableRow(children: [
            Text('Color:'),
            Text(model.pColor!),
          ]),
          TableRow(children: [
            Text('Size:'),
            Text(model.pSize!),
          ]),
        ],
      ),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFButton(
            onPressed: () {
              Get.to(() => ProductPageView(
                  vModel: ProductsModel.fromJson(model.toJson() ),
                  data: model.toString()));

            },
            text: 'View',
            icon: Icon(Icons.remove_red_eye, color: Colors.white),
            shape: GFButtonShape.pills,
          ),
          GFButton(
            onPressed: () {
              Get.to(() => ProductsEditView(
                model: model,
              ));
              // Get.to(() => VehicleEditView(
              //   model: model,
              // ));
            },
            text: 'Edit',
            icon: Icon(Icons.edit, color: Colors.white),
            color: Colors.green,
            shape: GFButtonShape.pills,
          ),
          GFButton(
            onPressed: () {
              controller.deleteProduct(model.pUniqueId!);
            },
            text: 'Delete',
            icon: Icon(Icons.delete, color: Colors.white),
            color: Colors.red,
            shape: GFButtonShape.pills,
          ),
        ],
      ),
    );
  }
}
