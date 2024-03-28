import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/budget_controller.dart';

class BudgetView extends StatefulWidget {
  const BudgetView({super.key});

  @override
  State<BudgetView> createState() => _BudgetViewState();
}

class _BudgetViewState extends State<BudgetView> {
  final BudgetController controller = Get.put(BudgetController());

  TextEditingController incomeNameController = TextEditingController();
  TextEditingController incomeAmountController = TextEditingController();
  TextEditingController expensesNameController = TextEditingController();
  TextEditingController expensesAmountController = TextEditingController();


  @override
  void initState() {
    super.initState();
    controller.calculate();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BudgetView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: incomeNameController,
                    decoration: const InputDecoration(
                      hintText: 'Income Name',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: incomeAmountController,
                    decoration: const InputDecoration(
                      hintText: 'Income Amount',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addIncome(
                        incomeNameController.text,
                        double.parse(incomeAmountController.text),
                      );
                    },
                    child: const Text('Add Income'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: expensesNameController,
                    decoration: const InputDecoration(
                      hintText: 'Expenses Name',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: expensesAmountController,
                    decoration: const InputDecoration(
                      hintText: 'Expenses Amount',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.addExpenses(
                        expensesNameController.text,
                        double.parse(expensesAmountController.text),
                      );
                    },
                    child: const Text('Add Expenses'),
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => Column(
              children: [
                Text('Total Income: ${controller.totalIncome.value}'),
                Text('Total Expenses: ${controller.totalExpenses.value}'),
                Text('Budget Left: ${controller.budgetLeft}'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.incomeName.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.incomeName[index]),
                  subtitle: Text(controller.incomeAmount[index].toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteIncome(index);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.expensesName.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(controller.expensesName[index]),
                  subtitle: Text(controller.expensesAmount[index].toString()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.deleteExpenses(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
