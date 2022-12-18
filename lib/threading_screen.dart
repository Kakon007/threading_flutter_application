import 'dart:isolate';

import 'package:flutter/material.dart';

class Threading extends StatefulWidget {
  Threading({Key? key}) : super(key: key);

  @override
  State<Threading> createState() => _ThreadingState();
}

class _ThreadingState extends State<Threading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Threading'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Threading'),
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                var revicePort = ReceivePort();
                Isolate.spawn(computeHeavyTask, revicePort.sendPort);
                revicePort.listen((message) {
                  print(message);
                });
              },
              child: const Text('Start'),
            )
          ],
        ),
      ),
    );
  }
}

computeHeavyTask(SendPort sendPort) {
  int sum = 0;
  for (int i = 0; i < 1000000000; i++) {
    sum += i;
  }
  sendPort.send(sum);
}
