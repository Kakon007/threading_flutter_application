import 'dart:isolate';

import 'package:flutter/material.dart';

var counterValue;

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
            Text('Counter Value: $counterValue'),
            const CircularProgressIndicator(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var revicePort = ReceivePort();
               await Isolate.spawn(computeHeavyTask, revicePort.sendPort);
                revicePort.listen((message) {
                  setState(() {
                    counterValue = message;
                    print('Counter Value: $message');
                  });
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
  for (int i = 0; i < 100000; i++) {
    sum += i;
  }
  sendPort.send(sum);
}
