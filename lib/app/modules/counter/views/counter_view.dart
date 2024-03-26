import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:untitled/models/counter_models.dart';


class CounterView extends ConsumerWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(stateProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme:  IconThemeData(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
        title: const Text('Counter'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${provider.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {
              provider.increment();
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
              provider.decrement();
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
