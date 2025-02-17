// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:untitled/app/modules/products/views/search_view.dart';
import 'package:untitled/app/modules/products/views/show_products_view.dart';
import 'package:untitled/app/modules/products/views/tabbar/all_products.dart';
import 'package:untitled/app/modules/products/views/tabbar/appliances.dart';
import 'package:untitled/app/modules/products/views/tabbar/bags.dart';
import 'package:untitled/app/modules/products/views/tabbar/beauty.dart';
import 'package:untitled/app/modules/products/views/tabbar/books.dart';
import 'package:untitled/app/modules/products/views/tabbar/clothes.dart';
import 'package:untitled/app/modules/products/views/tabbar/electronics.dart';
import 'package:untitled/app/modules/products/views/tabbar/fashions.dart';
import 'package:untitled/app/modules/products/views/tabbar/laptop_view.dart';
import 'package:untitled/app/modules/products/views/tabbar/phones.dart';
import 'package:untitled/app/modules/products/views/tabbar/shoes.dart';
import 'package:untitled/app/modules/products/views/tabbar/sports.dart';
import 'package:untitled/app/modules/products/views/tabbar/stationery.dart';
import 'package:untitled/app/modules/products/views/tabbar/toys.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/products_controller.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ProductsController controller = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 14,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  GFIconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      Get.to(() => ProductsSearchView());
                    },
                  ),
                  SizedBox(width: 10.0),
                  GFIconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Get.to(() => ShowProductsView());
                    },
                  ),
                  SizedBox(width: 10.0),
                ],
                centerTitle: false,
                title: wText('Products', size: 24),
                floating: true,
                snap: true,
                pinned: true,
                bottom: TabBar(
                  tabAlignment: TabAlignment.center,
                  isScrollable: true,
                  tabs: [
                    // All 1
                    Tab(
                      icon: Icon(Icons.all_inbox),
                        text: 'All'),
                    // Phones 2
                    Tab(
                      icon: Icon(Icons.phone_android),
                        text: 'Phones'),
                    // Laptops 3
                    Tab(
                      icon: Icon(Icons.laptop),
                        text: 'Laptops'),
                    // Electronics 4
                    Tab(
                      icon: Icon(Icons.electrical_services_outlined),
                        text: 'Electronics'),
                    // Clothes 5
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Clothes'),
                    // Shoes 6
                    Tab(
                      icon: Icon(Icons.snowshoeing_sharp),
                        text: 'Shoes'),
                  //Bags  7
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Bags'),
                  //Fashion 8
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Fashion'),
                  //Appliances 9
                    Tab(
                      icon: Icon(Icons.shopping_bag),
                        text: 'Appliances'),
                  //Beauty 10
                    Tab(
                      icon: Icon(Icons.favorite),
                        text: 'Beauty'),
                  //Toys 11
                    Tab(
                      icon: Icon(Icons.toys),
                        text: 'Toys'),
                  //Sports 12
                    Tab(
                      icon: Icon(Icons.umbrella),
                        text: 'Sports'),
                  //Books 13
                    Tab(
                      icon: Icon(Icons.book),
                        text: 'Books'),
                  //Stationery 14
                    Tab(
                      icon: Icon(Icons.archive),
                        text: 'Stationery'),

                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              AllProducts(),
              PhonesView(),
              LaptopView(),
              ElectronicsView(),
              ClothesView(),
              ShoesView(),
              BagsView(),
              FashionsView(),
              AppliancesView(),
              BeautyView(),
              ToysView(),
              SportsView(),
              BooksView(),
              StationeryView(),
            ],
          )),
    );
  }
}
