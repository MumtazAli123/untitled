// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/mix_widgets.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());

  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _buildAddArticleDialog();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: wText(
          controller.articleList.isEmpty
              ? 'No data found'
              // balance add and minus
              : controller.articleList[index].data()['title'],
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
            if (controller.articleList.isEmpty) {
              return const Center(
                  child: Text(
                'No data found',
                style: TextStyle(fontSize: 20),
              ));
            } else {
              return ListView.builder(
                restorationId: 'list',
                reverse: false,
                itemCount: controller.articleList.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _buildEditArticleDialog(
                                controller.articleList[index].id,
                                controller.articleList[index].data()['title'],
                                controller.articleList[index].data()['body'],
                                controller.articleList[index].data()['balance']);
                          },
                          icon: Icons.edit,
                          label: 'Edit',
                          flex: 1,
                          backgroundColor: Colors.green,
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            controller
                                .deleteArticle(controller.articleList[index].id);
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
                        child: wText(controller.articleList[index]
                            .data()['title']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase()),
                      ),
                      title: Text(controller.articleList[index].data()['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.articleList[index].data()['body']),
                          Text(
                              GetTimeAgo.parse(DateTime.parse(controller
                                  .articleList[index]
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
                              "- PKR: ${controller.articleList[index].data()['balance'] ?? 0}",
                              style: GoogleFonts.cabin(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                          : Text(
                              "+ PKR: ${controller.articleList[index].data()['balance'] ?? 0}",
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
}
