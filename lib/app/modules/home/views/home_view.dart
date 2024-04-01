// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/drawer/drawer.dart';

import '../../../../widgets/mix_widgets.dart';
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
            backgroundColor: controller.isBalance.value ? Colors.red : Colors.green,
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
          child: wText(
              controller.incomeList.isEmpty
                  ? 'No data found'
              // balance add and minus
                  : '${counterController.city.string} '
          ),
        ),
        centerTitle: true,
        actions: [
          // auth
          IconButton(
            onPressed: () {
              Get.toNamed('/auth');
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
                      trailing: controller.isBalance.value
                          ? Text(
                              "- PKR: ${controller.expenseList[index].data()['balance'] ?? 0}",
                              style: GoogleFonts.cabin(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                          : Text(
                              "+ PKR: ${controller.incomeList[index].data()['balance'] ?? 0}",
                              style: GoogleFonts.cabin(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
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
    final TextEditingController expansiveName = TextEditingController();
    final TextEditingController expansiveAmount = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: expansiveName,
                decoration: InputDecoration(
                    hintText: 'Balance',
                    labelText: 'Balance',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: expansiveAmount,
                decoration: InputDecoration(
                    hintText: 'Amount',
                    labelText: 'Amount',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
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
                controller.addExpense(expansiveName.text, expansiveAmount.text);
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
}
