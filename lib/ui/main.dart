import 'package:flutter/material.dart';
import '../classes/all.dart';
import 'NavBar.dart';

void main() => runApp(const MainCanvas());

class MainCanvas extends StatelessWidget
{
  const MainCanvas({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: const Text('BizBuddy',),
        ),
        body: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    );
  }
}