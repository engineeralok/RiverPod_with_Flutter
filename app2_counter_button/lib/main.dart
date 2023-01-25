import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() => runApp(const ProviderScope(
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App 2 Counter Button',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

extension OptionalInfixAdditon<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

// void sumIt() {
//   final int? a = 1;
//   final int? b = null;

//   final result = a + b;
//   print(result);
// }
class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
}

final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // sumIt();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            final text =
                count == null ? "Please Tap the Button" : count.toString();
            return Text(text);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: ref.read(counterProvider.notifier).increment,
              child: const Text("Tap me"),
            )
          ],
        ),
      ),
    );
  }
}
