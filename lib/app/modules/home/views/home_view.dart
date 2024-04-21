// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/drawer/drawer.dart';

import '../../../../widgets/mix_widgets.dart';
import '../../auth/views/mob_auth_view.dart';
import '../../counter/controllers/counter_controller.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final CounterController counterController = Get.put(CounterController());

  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green,
            heroTag: 'add',
            onPressed: () {
              _buildAddArticleDialog();
            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.red,
            heroTag: 'balance',
            onPressed: () {
              _buildExpenseDialog();
            },
            child: Icon(Icons.remove, color: Colors.white),
          ),
        ],
      ),
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
        title: TextButton(
          onPressed: (){
            _buildLocationDialog();
          },
          child: Obx(() => Text(
            'Total Balance: ${controller.totalIncome.value - controller.totalExpense.value}',
            style: TextStyle(
              color: controller.totalBalance.value >= 0
                  ? Colors.green
                  : Colors.red,
            ),
          )),
        ),
        centerTitle: true,
        actions: [
          // auth
          IconButton(
            onPressed: () {
              Get.isLogEnable = !Get.isLogEnable;
              Get.snackbar(
                'Log',
                Get.isLogEnable ? 'Enabled' : 'Disabled',
                snackPosition: SnackPosition.BOTTOM,


              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MobAuthView(),
                ),
                    (route) => false,
              );

            },
            icon: Icon(Icons.lock, color: Colors.green),
          ),
          IconButton(
            onPressed: () {
              controller.streamArticle();
            },
            icon: controller.isRefresh.value
                ? Icon(Icons.refresh, color: Colors.green)
                : Icon(Icons.refresh_outlined, color: Colors.red),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Obx(() {
            if (controller.incomeList.isEmpty) {
              return const Center(
                  child: Text(
                'No data found',
                style: TextStyle(fontSize: 20),
              ));
            } else {
              return ListView.builder(
                restorationId: 'list',
                reverse: false,
                itemCount: controller.incomeList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _buildEditArticleDialog(
                                controller.incomeList[index].id,
                                controller.incomeList[index].data()['title'],
                                controller.incomeList[index].data()['body'],
                                controller.incomeList[index].data()['balance']);
                          },
                          icon: Icons.edit,
                          label: 'Edit',
                          flex: 1,
                          backgroundColor: Colors.green,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            controller
                                .deleteArticle(controller.incomeList[index].id);
                          },
                          icon: Icons.delete,
                          label: 'Delete',
                          flex: 1,
                          backgroundColor: Colors.red,
                        ),
                      ],
                    ),
                    child: ListTile(
                      onTap: () {
                        _buildDetailDialog(
                            controller.incomeList[index].data()['title'],
                            controller.incomeList[index].data()['body'],
                            controller.incomeList[index].data()['balance'],
                            controller.incomeList[index].data()['created_at']);
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: wText(controller.incomeList[index]
                            .data()['title']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase()),
                      ),
                      title: Text(controller.incomeList[index].data()['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.incomeList[index].data()['body']),
                          Text(
                              GetTimeAgo.parse(DateTime.parse(controller
                                  .incomeList[index]
                                  .data()['created_at']
                                  .toString())),
                              style: GoogleFonts.cabin(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: Text(
                        controller.incomeList[index].data()['type'] == 'income'
                            ? '+ ${controller.incomeList[index].data()['balance']}'
                            : '- ${controller.incomeList[index].data()['balance']}',
                        style: TextStyle(
                            color: controller.incomeList[index].data()['type'] ==
                                    'income'
                                ? Colors.green
                                : Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }),
        ),
      ),
    );
  }

  void _buildAddArticleDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    final TextEditingController balanceController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Article'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(height: 10.0),
              TextField(
                maxLines: 3,
                controller: bodyController,
                decoration: InputDecoration(
                    hintText: 'Body',
                    labelText: 'Body',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(height: 10.0),
              // balance add and minus
              TextField(
                controller: balanceController,
                decoration: InputDecoration(
                    hintText: 'Balance',
                    labelText: 'Balance',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.addArticle(titleController.text, bodyController.text,
                    balanceController.text);
                controller.increment();
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _buildEditArticleDialog(id, data, data2, data3) {
    final TextEditingController titleController =
        TextEditingController(text: data);
    final TextEditingController bodyController =
        TextEditingController(text: data2);
    final TextEditingController balanceController =
        TextEditingController(text: data3.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Article'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(hintText: 'Body'),
              ),
              TextField(
                controller: balanceController,
                decoration: InputDecoration(hintText: 'Balance'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.updateArticle(id, {
                  'title': titleController.text,
                  'body': bodyController.text,
                  'balance': balanceController.text,
                  'created_at': DateTime.now().toString(),
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _buildExpenseDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    final TextEditingController balanceController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Article'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                    hintText: 'Title',
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(height: 10.0),
              TextField(
                maxLines: 3,
                controller: bodyController,
                decoration: InputDecoration(
                    hintText: 'Description',
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(height: 10.0),
              // balance add and minus
              TextField(
                controller: balanceController,
                decoration: InputDecoration(
                    hintText: 'Amount',
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.addArticle(titleController.text, bodyController.text,
                    balanceController.text);
                controller.decrement(
                  double.parse(balanceController.text),
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _buildLocationDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Location'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wText('City: ${counterController.city.string}'),
            wText('State: ${counterController.province.string}'),
            wText('Country: ${counterController.country.string}'),
            wText('Address: ${counterController.address.string}'),

          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),


    );
  }

  void _buildDetailDialog(data, data2, data3, data4) {
    Get.dialog(
      AlertDialog(
        title: Text('Detail'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            wText('Title: $data'),
            wText('Description: $data2'),
            wText('Amount: $data3'),
            wText('Created At: $data4'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
