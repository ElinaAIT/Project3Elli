import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startTest(BuildContext context, String testName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Запущен тест: $testName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор теста')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _startTest(context, 'ОРТ'),
              child: const Text('ОРТ'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startTest(context, 'SAT'),
              child: const Text('SAT'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startTest(context, 'ЕГЭ'),
              child: const Text('ЕГЭ'),
            ),
          ],
        ),
      ),
    );
  }
}
