import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static const routeName = "home";
  static const path = "/$routeName";

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
