import 'package:flutter/material.dart';
import '../classes/all.dart';

void main() => runApp(MainCanvas());

class MainCanvas extends StatelessWidget
{
  const MainCanvas({super.key});

  @override Widget build(BuildContext context)
  {
    return MaterialApp(home: Scaffold(appBar: AppBar(backgroundColor: Colors.black54, title: const Text('BizBuddy'),), body: Container(color: Colors.white,),),);
  }
}